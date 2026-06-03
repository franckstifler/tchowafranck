defmodule BlogTest do
  use Blog.DataCase

  alias Blog.Post

  describe "get_translations_for_post/1" do
    test "returns published posts with the same translation key" do
      post = insert_post!(slug: "source", language: "en", translation_key: "shared")
      translation = insert_post!(slug: "translation", language: "fr", translation_key: "shared")

      _unpublished =
        insert_post!(slug: "draft", published: false, language: "fr", translation_key: "shared")

      _other = insert_post!(slug: "other", language: "fr", translation_key: "other")

      assert Blog.get_translations_for_post(post) == [translation]
    end

    test "returns an empty list when the post is not part of a translation group" do
      post = insert_post!(slug: "source", translation_key: nil)

      assert Blog.get_translations_for_post(post) == []
    end
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
    |> Repo.insert!()
  end
end
