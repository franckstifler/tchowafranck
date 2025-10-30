defmodule BlogWeb.PageController do
  use BlogWeb, :controller

  def home(conn, _params) do
    posts = Blog.get_all_posts()
    render(conn, :home, posts: posts)
  end

  def show(conn, %{"slug" => slug}) do
    post = Blog.get_post_by_slug(slug)
    render(conn, :show, post: post)
  end

  def tag(conn, %{"tag" => tag}) do
    posts = Blog.get_posts_by_tag(tag)
    render(conn, :home, posts: posts, tag: tag)
  end

  def about(conn, _) do
    render(conn, :about)
  end

  def contact(conn, _) do
    render(conn, :contact)
  end
end
