defmodule BlogWeb.SitemapControllerTest do
  use BlogWeb.ConnCase

  alias Blog.Post

  test "GET /sitemap.xml lists posts, static pages and tags", %{conn: conn} do
    post = insert_post!(slug: "sitemap-post")

    conn = get(conn, "/sitemap.xml")

    assert response_content_type(conn, :xml) =~ "application/xml"
    body = response(conn, 200)

    assert body =~ "<urlset"
    assert body =~ "/posts/#{post.slug}"
    assert body =~ "<loc>http://localhost:4002/about</loc>"
    assert body =~ "<lastmod>2026-05-19</lastmod>"
  end

  test "GET /robots.txt points at the sitemap", %{conn: conn} do
    conn = get(conn, "/robots.txt")

    assert response_content_type(conn, :txt) =~ "text/plain"
    body = response(conn, 200)

    assert body =~ "User-agent: *"
    assert body =~ "Sitemap: http://localhost:4002/sitemap.xml"
  end

  defp insert_post!(attrs) do
    defaults = %{
      title: "Post #{System.unique_integer([:positive])}",
      blurb: "A short blurb",
      slug: "post-#{System.unique_integer([:positive])}",
      content: "<p>Post content</p>",
      published_date: ~N[2026-05-19 12:00:00],
      published: true,
      language: "en",
      translation_key: nil
    }

    %Post{}
    |> Post.changeset(Map.merge(defaults, Map.new(attrs)))
    |> Blog.Repo.insert!()
  end
end
