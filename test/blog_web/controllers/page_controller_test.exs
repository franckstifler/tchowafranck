defmodule BlogWeb.PageControllerTest do
  use BlogWeb.ConnCase

  alias Blog.Post

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "<main>"
  end

  test "GET /posts/:slug shows available translations", %{conn: conn} do
    post = insert_post!(slug: "source", language: "en", translation_key: "shared")

    translation =
      insert_post!(slug: "version-francaise", language: "fr", translation_key: "shared")

    conn = get(conn, "/posts/#{post.slug}")
    response = html_response(conn, 200)

    assert response =~ "Also available in"
    assert response =~ "French"
    assert response =~ ~s(/posts/#{translation.slug})
  end

  test "GET /posts/:slug hides translations section when there is no published translation", %{
    conn: conn
  } do
    post = insert_post!(slug: "source", language: "en", translation_key: "shared")

    _draft =
      insert_post!(
        slug: "version-francaise",
        published: false,
        language: "fr",
        translation_key: "shared"
      )

    conn = get(conn, "/posts/#{post.slug}")

    refute html_response(conn, 200) =~ "Also available in"
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
