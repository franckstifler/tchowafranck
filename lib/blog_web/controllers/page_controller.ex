defmodule BlogWeb.PageController do
  use BlogWeb, :controller

  def index(conn, _params) do
    posts = Blog.get_all_posts()

    render(conn, "index.html", posts: posts)
  end

  def show(conn, %{"slug" => slug}) do
    post = Blog.get_post_by_slug(slug)

    render(conn, "show.html", post: post)
  end

  def tag(conn, %{"tag" => tag}) do
    posts = Blog.get_posts_by_tag(tag)

    render(conn, "index.html", posts: posts, tag: tag)
  end

  def about(conn, _) do
    render(conn, "about.html")
  end

  def contact(conn, _) do
    render(conn, "contact.html")
  end
end
