defmodule BlogWeb.FeedControllerTest do
  use BlogWeb.ConnCase

  alias Blog.Post

  test "GET /feed/en returns only English posts as RSS", %{conn: conn} do
    en = insert_post!(slug: "english-post", title: "English Post", language: "en")
    fr = insert_post!(slug: "french-post", title: "French Post", language: "fr")

    conn = get(conn, "/feed/en")

    assert response_content_type(conn, :xml) =~ "application/rss+xml"
    body = response(conn, 200)

    assert body =~ "<rss"
    assert body =~ "<language>en</language>"
    assert body =~ "/posts/#{en.slug}"
    refute body =~ "/posts/#{fr.slug}"
  end

  test "GET /feed/fr returns only French posts", %{conn: conn} do
    _en = insert_post!(slug: "english-post", language: "en")
    fr = insert_post!(slug: "french-post", language: "fr")

    body = conn |> get("/feed/fr") |> response(200)

    assert body =~ "<language>fr</language>"
    assert body =~ "/posts/#{fr.slug}"
  end

  test "description is a plain-text excerpt with HTML stripped", %{conn: conn} do
    insert_post!(
      slug: "html-post",
      language: "en",
      content: "<p>Hello <strong>world</strong> from the feed.</p>"
    )

    body = conn |> get("/feed/en") |> response(200)

    assert body =~ "Hello world from the feed."
    refute body =~ "<strong>"
  end

  test "GET /feed.xml defaults to the English feed", %{conn: conn} do
    body = conn |> get("/feed.xml") |> response(200)
    assert body =~ "<language>en</language>"
  end

  test "GET /feed/:language with an unknown language returns 404", %{conn: conn} do
    conn = get(conn, "/feed/de")
    assert conn.status == 404
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
