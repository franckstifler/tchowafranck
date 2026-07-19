# AGENTS.md

Instructions for AI agents working in this repository. See [CLAUDE.md](CLAUDE.md) for the
full project memory — this file mirrors the essentials to avoid drift.

## What this is

A personal blog built with **Phoenix 1.8 + Ecto/Postgres**. Posts are markdown files in
`priv/posts/*.md` that `Blog.PostParser` loads into the `posts` table at boot (rendered to
HTML with Earmark). The DB is the source of truth at request time; you edit the markdown.

## Working conventions

- **Add/edit a post** by editing a file under `priv/posts/`. Frontmatter lines are
  `key: value`, separated from the markdown body by a `-----` line. Required fields:
  `title, published, published_date, blurb, language`; optional: `translation_key`, `tags`
  (comma-separated). `slug` is derived from the title. Restart the server to reload.
- **Queries** go through the `Blog` context (`lib/blog.ex`) — reuse existing functions
  before adding new ones.
- **Feeds/sitemap/robots**: rendered via EEx templates compiled with
  `EEx.function_from_file/4` (`BlogWeb.FeedXML`, `BlogWeb.SitemapXML`) and sent with an
  explicit content type; shared helpers in `BlogWeb.XMLHelpers`. RSS is per-language with
  ~255-char plain-text excerpts. Use `url(~p"...")` for absolute URLs so they respect
  `PHX_HOST`.

## Commands

- `mix setup` — deps + DB setup
- `mix phx.server` — run locally
- `mix test` — tests
- `mix format` — format before committing

## Conventions

- Follow existing module/naming patterns. Keep controllers thin; put data access in `Blog`.
- Don't reintroduce a static `priv/static/robots.txt` — it is served dynamically.
