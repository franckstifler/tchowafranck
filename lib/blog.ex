defmodule Blog do
  import Ecto.Query

  alias Blog.{Post, Tag, Repo}

  def get_all_posts() do
    query =
      from p in Post,
        where: [published: true],
        preload: [:tags],
        order_by: [desc: :published_date]

    Repo.all(query)
  end

  def get_post_by_slug(slug) do
    Repo.get_by(Post, slug: slug)
    |> Repo.preload([:tags])
  end

  def get_posts_by_tag(tag) do
    query =
      from p in Post,
        join: t in assoc(p, :tags),
        where: t.name == ^tag,
        preload: [:tags],
        order_by: [desc: :published_date]

    Repo.all(query)
  end

  def insert_post(params) do
    Post
    |> Repo.get_by(slug: params.slug)
    |> Repo.preload([:tags])
    |> case do
      nil ->
        %Post{}
        |> Post.changeset(params)
        |> Ecto.Changeset.put_assoc(:tags, parse_tags(Map.get(params, :tags, "")))
        |> Repo.insert()

      post ->
        post
        |> Post.changeset(params)
        |> Ecto.Changeset.put_assoc(:tags, parse_tags(Map.get(params, :tags, "")))
        |> Repo.update()
    end
  end

  defp parse_tags(params) do
    params
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.downcase/1)
    |> insert_and_get_all()
  end

  defp insert_and_get_all(names) do
    maps = Enum.map(names, &%{name: &1})
    Repo.insert_all(Tag, maps, on_conflict: :nothing)
    Repo.all(from t in Tag, where: t.name in ^names)
  end
end
