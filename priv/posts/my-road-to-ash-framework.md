-----
title: My road to Ash Framework
published: true
published_date: 2026-09-25 12:00:00
blurb: A personal look at why I started moving a long-running Phoenix project to Ash, the mistakes I made on the way, and the compilation crime scene I had to investigate to understand what Ash was actually trying to tell me.
language: en
tags: elixir, ash, phoenix, software-development, Nkapio
-----

Hi all,

Every long-running Elixir codebase eventually reaches an age where it starts writing its own diary entries in the form of TODO comments. Ours had quite a few, and most of them, if you translated them honestly, said some version of "we know, we know, we'll fix it later." This is the story of the framework that finally made "later" arrive.

I have already written about a compilation issue I faced in an Ash project, but that post started in the middle, like a heist movie that opens with the vault already cracked. This one is the part before that — how I ended up in the vault in the first place, what was broken before I got there, and why I would still, somehow, do it again.

This is not a tutorial. It is more a story of a long-running project, some architectural fatigue, and the search for a better way to model business software.

## The project before Ash

For years, I have been working on [Nkapio](https://nkapio.com/), a business management platform designed to help service businesses manage their day-to-day operations in one place. Nkapio brings together features such as appointments, customers, sales, invoicing, inventory, team management, and reporting, giving businesses a simpler way to stay organized and focus on their customers. As the product continues to evolve, having a more structured and maintainable backend has become an important part of being able to deliver new features faster and scale the platform with confidence.

The project started as a Phoenix and Vue.js application. It worked. We had contexts, schemas, controllers, background jobs, and everything you expect in a Phoenix app.

But over time, the business logic started spreading, and a few specific pains kept coming back to bite us.

**Multitenancy** was scattered by hand. Nkapio serves many businesses, and naturally, one business should never see another business's invoices. In plain Phoenix, that meant remembering to add a `where business_id: ^business_id` to every single query, in every context function, forever, and hoping that everyone on the team remembered it every single time. It worked, in the sense that a car with no seatbelt also works, right up until the day it really needs to.

**Pagination** was reinvented per feature. One list used `LIMIT`/`OFFSET` by hand. Another used a half-finished keyset implementation someone started and never finished. A third just loaded everything and paginated in the frontend, which worked beautifully until a customer with eleven thousand invoices opened their dashboard and my browser had a small existential crisis.

**Policies** did not really exist as a concept. Permissions were checked in the controller here, in the LiveView there, occasionally in the Vue component for good measure, which is a very charming way of saying "occasionally not checked at all." Some rules lived in contexts. Some lived in schemas. Some were hidden in forms. Some were enforced only by the UI, which is a nice way of saying "enforced by hope."

**Calculations** like a simple `total_due` were computed independently in four different places — a context function, a serializer, and two separate Vue components — each with its own subtly different rounding, so that occasionally two screens would disagree, politely, about how much a customer owed.

Nothing was completely broken. But the architecture had started asking politely for more discipline than we were, in practice, willing to give it. That is usually how complexity enters an application. Not as a big explosion, but as a hundred small "I'll clean this up later" decisions that all make perfect sense on their own, and terrible sense together.

## Why Ash became interesting

Ash attracted me because it forces you to describe your application around resources, actions, policies, and domains, whether you feel like it that day or not.

For a business application like Nkapio, that matters.

An invoice is not just a database table. A customer is not just a schema. A payment is not just a row inserted somewhere by whichever function got there first. These things have rules. They have allowed actions. They have authorization logic. They have relationships with other parts of the system, and opinions about who is allowed to touch them.

With Ash, I liked the idea that these rules could live closer to the resource itself instead of being scattered across contexts, forms, controllers, and the collective memory of whoever wrote that part two years ago.

The promise was not only less code. The promise was better structure — and, selfishly, fewer moments of opening a file and asking it "who hurt you."

## My "what is Ash, actually" moment

I came into this from Phoenix Contexts and a fair amount of DDD reading, so my first instinct was to file Ash under "fancier contexts with authorization built in." That instinct is wrong, and it took me a while to unlearn it.

Ash is much more than your contexts, and much more than your authorizer. What it actually does is give superpowers to your Ecto schemas. That reframing changed everything for me. If you have already written an Ecto schema with changeset functions inside it, you already know most of what you need to write an Ash resource with actions — you are just moving logic that used to live in loose functions into a declarative shape the framework can see, introspect, and reason about for you.

And here is the part that surprised me most: you can work with Ash resources without touching your domains at all for months. That's a design decision, not a limitation, and it means the learning curve is more of a staircase than a cliff — you can live comfortably on the "resource" step for a good while before you ever need to think hard about domain boundaries.

Getting to understand *why* you need any of it can take some time. I read the guides — the how-tos, the advanced sections, then the advanced sections again — more times than I'd like to admit. I watched Zach's livestreams. I went down YouTube rabbit holes at hours I am not proud of. And trust me, there are always more "wow" moments waiting, given how much power this tool hands you, without any notable compromise on the Elixir and Ecto fundamentals you already know. I still reach for my Ash resources as plain Ecto schemas whenever I want to do something fancy — that escape hatch never closes, which is exactly what makes the rest of it trustworthy.

## The migration mindset

I did not want to rewrite everything in one big move. That would have been irresponsible, and Nkapio already had real users doing real business on it, which tends to make "let's just rewrite the whole backend this weekend" a less charming idea than it sounds.

The first step was to move gradually, resource by resource, rather than attempting some heroic big-bang rewrite.

I ran with a single `Ash.Domain` for a long time. Partly because it was simply easier for us at the start — fewer moving pieces to think about while we were still learning the DSL. But mostly because, back then, relationships between resources that lived in different domains needed a bit of extra configuration to work smoothly, or you ended up duplicating resources across domains just to keep those relationships clean. One domain sidestepped the whole question. That limitation doesn't exist anymore — Ash has since made cross-domain relationships a non-issue — but at the time, it was a genuinely reasonable trade-off, not a mistake I was making out of laziness.

The bill still came due eventually, just for a different reason: one domain holding everything meant one very large surface for the compiler to rebuild whenever something inside it changed. Splitting resources into proper, smaller domains once the tooling made that painless again was less "undoing a mistake" and more "finally taking Ash up on an offer it had been making for a while."

Ash gives you powerful tools, but it does not remove the need to design boundaries. If your domains are poorly shaped, Ash will not politely look away. It will make you feel it, directly, every time you save a file.

## What actually got fixed

Once the resources were properly shaped, the four pains from "the project before Ash" more or less dissolved, and each one dissolved in a specific, satisfying way.

**Multitenancy** stopped being a discipline problem and became a declaration:

```elixir
defmodule Nkapio.Billing.Invoice do
  use Ash.Resource,
    domain: Nkapio.Billing,
    data_layer: AshPostgres.DataLayer

  multitenancy do
    strategy :attribute
    attribute :business_id
  end

  # ...
end
```

Every action on that resource now respects tenancy by default. There is no query anyone can forget to scope, because the scoping isn't a habit anymore, it's structural. The class of bug that once leaked a report across businesses is now, for all practical purposes, not a bug this codebase can produce.

**Pagination** stopped being reinvented per feature, because it's just there:

```elixir
actions do
  read :list_invoices do
    pagination offset?: true, keyset?: true, default_limit: 25
  end
end
```

One implementation, offset or keyset depending on what the screen needs, instead of three half-finished ones competing for my attention.

**Policies** became declarative, sitting right next to the resource they govern instead of hiding in three unrelated files:

```elixir
policies do
  policy action_type(:read) do
    authorize_if relates_to_actor_via(:business)
  end

  policy action_type([:create, :update]) do
    authorize_if actor_attribute_equals(:role, :owner)
    authorize_if actor_attribute_equals(:role, :manager)
  end
end
```

I can now answer "who can do what to this resource" by reading one block, instead of grepping the codebase and hoping.

**Calculations and aggregates** moved out of the UI and into the resource, once and for all:

```elixir
calculations do
  calculate :total_due, :decimal, expr(amount - amount_paid)
end

aggregates do
  count :order_count, :orders
  sum :lifetime_value, :orders, :total
end
```

One `total_due`. One source of truth. No more two screens quietly disagreeing about what a customer owes.

None of this means Ash is a magic wand — designing good resources and boundaries still takes real thought, and I still occasionally get it wrong. But the difference between "this is hard because the domain is genuinely complex" and "this is hard because we have four undocumented implementations of the same rule" is enormous, and Ash moved almost all of my pain from the second category into the first.

## The toolkit I fell in love with

Somewhere in the middle of all this, I stopped thinking of Ash as just a resource layer and started noticing the ecosystem around it, and that's honestly where it won me over completely.

**Hooks** confused me at the beginning — where does this go, `before_action` or `change`, a `Ash.Resource.Change` module or an anonymous function inline, a `Ash.Resource.Preparation` or something else entirely. It took real effort to build the mental model. But once it clicked, I found myself reaching for Ash's changes and hooks instead of `Ecto.Multi` almost every time, and honestly, I don't miss `Ecto.Multi` much. Composable, resource-aware hooks that know about the action they're attached to are just a nicer way to think about a multi-step operation than a bag of named steps threaded through a pipeline.

**AshPhoenix** is, without exaggeration, unmatched in the Phoenix world. Turning a resource's actions straight into `AshPhoenix.Form` with validation, nested forms, and error handling that actually respects your Ash policies and actions saved me from rewriting the same form-handling boilerplate for the twentieth time.

**AshGraphql**, **AshJSONAPI**, and **AshTypescript** are where the "describe it once" promise really pays off. I define a resource and its actions once, and I can expose a GraphQL API, a JSON:API, and get generated TypeScript types on the frontend, all from the same source of truth, instead of hand-maintaining three parallel descriptions of the same invoice that inevitably drift apart.

And then there's **AshOban**, which I've started calling the glue that makes the world a better place, only half joking. Turning an action into a reliably retried, observable background job is close to trivial, and it plays so well with the rest of the ecosystem that background work stops feeling like a separate system you have to reason about on its own. Zach wrote a great walkthrough of exactly this kind of thing — [sending emails with Ash](https://www.zachdaniel.dev/p/sending-emails-with-ash) — that's worth reading if you want to see the glue in action.

## Trusting the trailer

I'll admit something a little sentimental here: the same way I trusted José to keep delivering the best of what the Elixir world could be, I started trusting Zach to deliver the best tool for building applications in Elixir. And I trusted Ash *before* it was easy to trust — before `Ash.Api` became `Ash.Domain`, before UUIDs were the sensible default, before Cinder, before AshOban, before AshMoney, and a handful of other pieces of tooling that now feel indispensable. I trusted it because the trailer for the movie actually delivered.

A world where I can define a policy, add an aggregate — a count or a sum of orders — filter across all of it, and simply get back the data that belongs to the one user asking for it: that world turned out to be real, not a slide in a conference talk. We've had our disagreements, Ash and I — plenty of them, and God knows I've had questions. But the team behind it has always been there to answer, to fix, or at the very least to argue the point with me properly. That kind of responsiveness is rare enough that it's worth mentioning on its own.

## What felt good

The first thing I appreciated was how explicit actions became.

Instead of asking, "Where is this business operation implemented?", you can look at the resource and see what can be done with it. Create, update, destroy, custom actions, validations, changes, policies. The resource becomes a stronger description of the business object, and future-me stops having to reverse-engineer past-me's intentions from four different files.

Another good part was the consistency. Once you understand the Ash way, many resources start following the same pattern. That is valuable in a project that will live for years, and it is genuinely nice to onboard someone new and have them find a `Sale` resource that looks like the `Invoice` resource they already understood, instead of a surprise party of inconsistent conventions.

## What hurt: a compilation crime scene

Ash has a learning curve. There is no point pretending otherwise.

When you come from regular Phoenix contexts, you are used to writing functions exactly where you want them. Ash asks you to think in terms of resources, actions, preparations, changes, calculations, aggregates, policies, and domains. It can feel heavy at first, like being handed a very well-organized toolbox when you were expecting a hammer.

The real pain, though, was compilation. Domains are among the heavier parts to compile, and when you accidentally create compile-time dependencies between your web layer and your domains, the developer experience degrades fast — and quietly, which is worse.

I changed one LiveView file — a genuinely small change — and saved it. My terminal responded by recompiling several unrelated domains, as if I had asked it to rebuild the pyramids instead of tweak a button label. At first, I blamed Ash. Eventually I went digging with `mix compile --verbose` and `mix xref graph --sink`, and found two problems, both entirely of my own making, both hiding in places I would never have thought to look:

```elixir
# lib/nkapio/notifications/invoice_notifier.ex
defmodule Nkapio.Notifications.InvoiceNotifier do
  use Phoenix.VerifiedRoutes,
    endpoint: NkapioWeb.Endpoint,
    router: NkapioWeb.Router

  def invoice_url(invoice) do
    url(~p"/invoices/#{invoice.id}")
  end
end
```

A notifier module — living deep in my business logic, nowhere near anything that should have cared about routing — was using `Phoenix.VerifiedRoutes` to build a nice, verified link for an email. Convenient. Also a direct compile-time dependency from a domain module straight into the router and the endpoint, which meant any change to the web layer rippled straight back into that domain, and from there into everything that depended on it.

The second culprit was quieter: a token helper, shared across contexts, that pulled in a module which itself depended on the endpoint for configuration. One indirect hop, easy to miss, still enough to keep the dependency graph tangled.

Ash did not create either of these problems. What it did was make them expensive enough, fast enough, that I finally had to go looking. In a plain Phoenix app, those same dependencies would have sat there quietly for years, costing me a few extra seconds per compile that I would never have noticed or attributed to anything in particular. Ash's domain compilation model has less patience for that kind of thing, and honestly, in hindsight, it was doing me a favor by being so loud about it.

The fix, once found, was almost boring: move the URL-building logic out of the notifier and into the web layer where it belonged, pass in a plain string instead of a verified route, and break the token helper's accidental dependency on endpoint config. A few lines changed. The recompile storm stopped.

But even with clean dependencies, there is a baseline cost that doesn't fully go away: Ash and its DSL extensions simply take real time to compile, on top of your own code. I don't just feel that locally, where it's an inconvenience. I feel it in GitHub Actions minutes and in deploy times, and both of those things cost actual money, not just patience. It's not dramatic, but it's real, and it's worth budgeting for when you're estimating how long a pipeline or a release is going to take.

## What I learned

My biggest lesson is that Ash rewards discipline, and bills you retroactively for the lack of it.

If your resources are well designed, your domains are properly separated, your tenancy is consistent everywhere, your policies are legible instead of merely functional, and your dependencies are clean, Ash can give you a strong foundation for a serious business application.

But if you bring messy boundaries into Ash, it will not magically fix them. Sometimes it will expose them faster, and louder, and usually right when you are trying to ship something else entirely.

That is not a bad thing. It is uncomfortable, but useful — a bit like a doctor who tells you the truth instead of the thing you wanted to hear.

## Would I still choose Ash?

Yes, for the kind of application Nkapio is.

For a small CRUD app, Ash may be more than you need, in the same way a filing cabinet is more than you need for three receipts. For a business platform with many rules, permissions, tenants, workflows, and relationships, I think it is worth considering seriously, and worth budgeting real time for the learning curve rather than pretending it isn't there.

I prefer that kind of difficulty to an application where the business logic is slowly, quietly disappearing into random functions no one remembers writing.

Ash is not magic. It is not a shortcut around architecture. But it gives you a language and a structure for building business software in Elixir.

For Nkapio, that is exactly the direction I wanted to move toward. And if you happen to run a service business anywhere in Africa and you're tired of juggling appointments, invoices, inventory, and your team across five different tools that don't talk to each other, that's more or less the entire reason [Nkapio](https://nkapio.com/) exists — go take a look.