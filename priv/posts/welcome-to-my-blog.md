---
title: Welcome to my blog
published: true
published_date: 2019-03-17 12:00:00
blurb: A beginning to a new and hopefully long journey.
tags: elixir, css
---

Welcome once more, I'm very excited on this new challenge awaiting me, but it's something I always dreamed of: blogging. I've been blogging here [franckstifler.blogspot.com](https://www.franckstifler.blogpot.com), but I decided to build a new blog by myself and put in the efforts to maintain a community.

## Development
I build this blog using Elixir and Phoenix, that we will talk so much about on this blog, inspired by other great people works: [jackmarchant.com](https://www.jackmarchant.com).
The blog is code is very simple and works at follows:
- I write articles in markdown
- At each deploy, a task (we will talk about in a comming article) navigates in the folder of the markdown files, and converts it article to a valid html code using the [Earmark](https://github.com/pragdave/earmark/blob/master/README.md) library.
- The html code from the markdown is stored in the database, and it's content displayed using the `raw` function of Phoenix.

The frontend part is just made of CSS that I wrote, no other library was used. The Phoenix web server renders the EEx templates and sends them to the browser. We will discuss about some of the animations on the links, and other CSS features.

## Hosting
The website is hosted on Heroku, and I'm planning to purchase a custom domain name as soon as possible. 

## Code
The source code of the blog is on my GitHub account: [blog source code](https://github.com/franckstifler/tchowafranck)

## Future Goals
- Improve the mobile user interface
- Publish content frequently
- Include (email) subscriptions

Stay tuned