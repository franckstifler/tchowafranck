defmodule BlogWeb.SitemapController do
  use BlogWeb, :controller

  def index(conn, _params) do
    posts = Blog.get_all_posts()

    tags =
      posts
      |> Enum.flat_map(& &1.tags)
      |> Enum.map(& &1.name)
      |> Enum.uniq()
      |> Enum.sort()

    translations =
      posts
      |> Enum.reject(&(&1.translation_key in [nil, ""]))
      |> Enum.group_by(& &1.translation_key)

    body =
      BlogWeb.SitemapXML.render(%{posts: posts, tags: tags, translations: translations})

    conn
    |> put_resp_content_type("application/xml")
    |> send_resp(200, body)
  end

  def robots(conn, _params) do
    body = """
    User-agent: *
    Allow: /

    Sitemap: #{url(~p"/sitemap.xml")}
    """

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, body)
  end
end
