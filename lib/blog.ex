defmodule Blog do
  import Ecto.Query

  alias Blog.{Post, Tag, Repo}

  def get_posts() do
    query =
      from p in Post, where: [published: true], preload: [:tags], order_by: [desc: :inserted_at]

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
    |> Enum.reject(& &1 == "")
    |> Enum.map(&String.downcase/1)
    |> insert_and_get_all()
  end

  defp insert_and_get_all(names) do
    maps = Enum.map(names, &%{name: &1})
    Repo.insert_all(Tag, maps, on_conflict: :nothing)
    Repo.all(from t in Tag, where: t.name in ^names)
  end
end
