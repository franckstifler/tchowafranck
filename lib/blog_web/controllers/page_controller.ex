defmodule BlogWeb.PageController do
  use BlogWeb, :controller

  def index(conn, _params) do
    posts = Blog.get_posts()

    render(conn, "index.html", posts: posts)
  end
end
