defmodule BlogWeb.FeedController do
  use BlogWeb, :controller

  @languages ~w(en fr)

  def index(conn, params) do
    language = Map.get(params, "language", "en")

    if language in @languages do
      posts = Blog.get_posts_by_language(language)
      body = BlogWeb.FeedXML.render(%{language: language, posts: posts})

      conn
      |> put_resp_content_type("application/rss+xml")
      |> send_resp(200, body)
    else
      conn
      |> put_status(:not_found)
      |> put_view(BlogWeb.ErrorHTML)
      |> render(:"404")
    end
  end
end
