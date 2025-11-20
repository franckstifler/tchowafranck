---
title: How I fixed my compilations issues in my Ash Project
published: true
published_date: 2025-11-20 12:00:00
blurb: Find and solve compilation issues
tags: elixir, ash, compilation
---

Hi all. I did not want to start my Ash series with this article, but I think it's worth it.

I've been building a multitenant app for years now [Servixo](https://mbc.monbord.com/). It's an application aimed at businesses selling Services and Products. We aim to provide a clean an easy invoicing, billing, ordering, online services etc... platform.

It was a Phoenix, Vue.js project initially and we decided to move it to Ash (more on this in new articles).

Everything went well until I encountered compilations issues. I was modifying a single liveview file, and had all of my domains (7 of them) recompile; *Domains are one of the heaviest things to recompile in Ash*. That's about 5s lost everytime I'm saving my liveview files. I always though Ash was doing something anoying behind the scenes, and that somehow there was some relations between my domains I was not seeing.

This is not related to Ash only, if you feel you don't understand your Elixir recompile cycles, they're somewhere in your code that's causing that bad DX.

## Where did my troubles come from?
The first trouble I had was having all the resources in one Domain. It was intentionnal because we were migrating from an existing structure with Phoenix Contexts, and putting everything in a single Domain was the easiest thing to do and easy to refactor. I never intended the compilation to be as impacted. Splitting the app in the corresponding domains solved the first issue we faced.

The secound trouble was not detectable from eyesigth. I have a notifier.ex in my app, which build emails to send to users. And because I wanted to have route verified using *Phoenix.VerifiedRoutes* `(~p"/route)`, I did this naive thing in my notifier code:

```elixir
use Phoenix.VerifiedRoutes,
    router: MyApp.Router,
    endpoint: MyApp.Endpoint,
    statics: ~w(images assets)
```

Little would I have known it will be the cause of all my recompilation cycles.

## How did I solve the issue?
I proceeded in steps:
1. Identify recompiling files related to a touched/modified file
2. Identify the relationship between the two files.

This article [Avoiding recompilation hell in Elixir with mix xref](https://r.ena.to/blog/avoiding-recompilation-hell-in-elixir-with-mix-xref/) by Renato Massaro paved the solution I found.

### Identify recompiling files related to the touched/modified file
```
$ mix compile --verbose 
```
This will list the files that are recompiled after your file changes.

```
Compiled lib/myapp/file1.ex
Compiled lib/myapp/file2.ex
Compiled lib/myapp_web/live/budget/file_live.ex
Compiled lib/myapp/file3.ex
Compiled lib/myapp/file4.ex
```
### Identify the relationship between the two files

Renato then suggests to find the relation between the last file `file4.ex` and the file I just touched/modified `file_live.ex`.

```
$ mix xref graph --source lib/myapp/file4.ex --sink lib/myapp_web/live/budget/file_live.ex
```

This will list a dependency tree having `file4.ex` at the top. Locate your `file_live.ex` and find its ancestors in the tree bottom to top. You'll find the cause of the recompilation of that file. In most cases *transitive compile-time dependencies* are the reason you have many files recompiling.

In my case I just had to remove the `use Phoenix.VerifiedRoutes...` from my notifier module and just use plain urls.

## Final notes
I also found that I had another dependency in my app:

```elixir
defmodule MyApp.Token do
  @moduledoc false
  @salt "very_long_salt_used_here"
  @max_age 60 * 60 * 48

  def sign(data) do
    Phoenix.Token.sign(MyApp.Endpoint, @salt, data)
  end

  def verify(token, max_age \\ @max_age) do
    Phoenix.Token.verify(MyApp.Endpoint, @salt, token, max_age: max_age)
  end
end
```

I was calling MyApp.Token in a Resource, for `signing` and `verifying` tokens.
Since my resource is a compile time deps for my Domain, and `MyApp.Endpoint` has a dep with `MyApp.Router`, I had a transitive dep with my Liveview file too!!!. I just deleted the file, and called directly `Phoenix.Token.sign...` directly in my resource, which solved that case.