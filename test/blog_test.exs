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

  describe "delete_posts_except/1" do
    test "deletes orphaned posts (including their tags) and keeps the rest" do
      keep = insert_post!(slug: "keep")
      {:ok, tagged} = Blog.insert_post(post_params(slug: "orphan-with-tags", tags: "elixir, phoenix"))
      orphan = insert_post!(slug: "orphan")

      deleted = Blog.delete_posts_except(["keep"])

      assert Enum.sort(deleted) == ["orphan", "orphan-with-tags"]
      assert Blog.get_post_by_slug("keep").id == keep.id
      refute Blog.get_post_by_slug("orphan")
      refute Blog.get_post_by_slug(tagged.slug)
      refute Blog.get_post_by_slug(orphan.slug)
    end

    test "is a no-op when given an empty slug list" do
      post = insert_post!(slug: "keep")

      assert Blog.delete_posts_except([]) == []
      assert Blog.get_post_by_slug("keep").id == post.id
    end
  end

  defp post_params(attrs) do
    Enum.into(attrs, %{
      title: "Post #{System.unique_integer([:positive])}",
      blurb: "A short blurb",
      slug: "post-#{System.unique_integer([:positive])}",
      content: "<p>Post content</p>",
      published_date: ~N[2026-05-19 12:00:00],
      published: true,
      language: "en"
    })
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
