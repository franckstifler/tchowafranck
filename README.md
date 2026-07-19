# Franck Tchowa — Blog

[francktchowa.gigalixirapp.com](http://francktchowa.gigalixirapp.com/)

Franck Tchowa AKA franckstifler — the source code of my personal blog. Built with
[Phoenix](https://www.phoenixframework.org/) and PostgreSQL. Articles are written in
Markdown, support English/French translations, and are exposed via per-language RSS feeds
and an XML sitemap.

## Stack

- Phoenix 1.8 (Bandit) + Ecto/PostgreSQL
- Earmark for Markdown → HTML
- Timex for date formatting

## Getting started

Requires Elixir/Erlang and a running PostgreSQL.

```bash
mix setup          # fetch deps, create + migrate the database, seed
mix phx.server     # start the server at http://localhost:4000
```

## Writing a post

Create a Markdown file in `priv/posts/`. Each file has a frontmatter block, a `-----`
separator, then the body:

```
title: My Post Title
published: true
published_date: 2026-05-19 12:00:00
blurb: One-sentence summary shown in listings.
language: en
translation_key: my-post-title
tags: elixir, phoenix
-----
# Hello

Body written in **Markdown**.
```

- `slug` is generated automatically from the title.
- `language` is `en` (default) or `fr`. Link translations of the same article by giving
  them the same `translation_key`.
- `tags` is an optional comma-separated list.

Posts are loaded into the database at startup by `Blog.PostParser`, so **restart the
server** after adding or editing a file.

## Feeds & SEO

| URL | Description |
|-----|-------------|
| `/feed.xml` | RSS feed (English, default) |
| `/feed/en`, `/feed/fr` | Per-language RSS feeds |
| `/sitemap.xml` | XML sitemap (posts, pages, tags, with `hreflang` alternates) |
| `/robots.txt` | Dynamic robots.txt pointing to the sitemap |

RSS item descriptions are a ~255-character plain-text excerpt of the article.

## Tests

```bash
mix test
```

## Deployment

Deployed on Gigalixir. Set `PHX_HOST` (and the usual Phoenix release env vars) in
production — absolute URLs in the feeds, sitemap, and robots.txt are derived from it. See
`config/runtime.exs`.

## TODO

- [ ] implement subscriptions
