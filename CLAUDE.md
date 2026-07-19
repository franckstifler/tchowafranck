# CLAUDE.md

Project memory for the personal blog of Franck Tchowa.

## Stack

- **Phoenix 1.8** (Bandit adapter) + **Ecto/Postgres**
- **Earmark** — markdown → HTML rendering
- **Timex** — date formatting
- Server-rendered HTML (controllers + HEEx). LiveView is available but the blog pages are
  plain controller actions.

## How posts work

Posts are authored as markdown files in `priv/posts/*.md`. On application boot,
`Blog.PostParser` (a supervised `Task`) reads every file, parses it, renders the body to
HTML with Earmark, and upserts it into the `posts` table via `Blog.insert_post/1` (keyed on
`slug`). **The database is the source of truth at request time; the markdown files are the
source you edit.**

### Post file format

Frontmatter, then a `-----` separator line, then the markdown body:

```
title: My Post Title
published: true
published_date: 2026-05-19 12:00:00
blurb: One-sentence summary shown in listings and as RSS fallback.
language: en
translation_key: my-post-title
tags: elixir, phoenix
-----
# Body in markdown...
```

- Each frontmatter line is split on the first `": "` — values must follow that exact form.
- `slug` is derived from `title` by `Blog.PostParser.slugify/1` (not set in frontmatter).
- `language` defaults to `"en"`; use `"fr"` for French.
- `translation_key` links the language variants of the same article together.
- `tags` is a comma-separated list (handled separately from the changeset cast).

To add/update a post: edit/create the `.md` file and restart the server so PostParser
re-runs.

## Key modules

- `Blog` (`lib/blog.ex`) — context with all queries: `get_all_posts/0`,
  `get_posts_by_language/1`, `get_post_by_slug/1`, `get_posts_by_tag/1`,
  `get_translations_for_post/1`, `get_related_posts/2`, `get_latest_posts/1`, comments.
- `Blog.Post` (`lib/blog/post.ex`) — schema: `title, content, slug, published_date,
  published, blurb, language, translation_key`, many_to_many `:tags`, has_many `:comments`.
- `BlogWeb.PageController` — `home`, `show`, `tag`, `about`, `contact`, `create_comment`.
- `BlogWeb.Router` — routes under the `:browser` pipeline.

## Routes

```
GET  /                     blog index
GET  /posts/:slug          single post
POST /posts/:slug/comments comment submission
GET  /tags/:tag            posts by tag
GET  /about, /contact      static pages
GET  /feed.xml             RSS (English, default)
GET  /feed/:language       per-language RSS (en, fr)
GET  /sitemap.xml          XML sitemap
GET  /robots.txt           dynamic robots.txt (points to the sitemap)
```

## RSS / sitemap / robots conventions

- Feeds and sitemap are rendered from EEx templates compiled into view modules via
  `EEx.function_from_file/4` (`BlogWeb.FeedXML`, `BlogWeb.SitemapXML`), then sent with an
  explicit content type from the controller (`send_resp`). They do **not** use Phoenix
  format negotiation.
- Shared rendering helpers live in `BlogWeb.XMLHelpers` (`excerpt/3`, `xml_escape/1`,
  `rfc822/1`, `w3c_date/1`).
- RSS feeds are **per-language**; each `<item>` description is a **~255-char plain-text
  excerpt** of the post content (HTML stripped), falling back to `blurb`.
- Absolute URLs come from verified routes (`url(~p"...")`), so they respect `PHX_HOST` in
  production (`config/runtime.exs`). `robots.txt` is served dynamically for the same reason
  (it is no longer a static file).

## Commands

- `mix setup` — install deps + create/migrate DB + seed
- `mix phx.server` — run locally (http://localhost:4000)
- `mix test` — run tests
