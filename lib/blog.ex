defmodule Blog do
  import Ecto.Query

  alias Blog.{Post, Tag, Comment, Repo}

  def get_all_posts() do
    query =
      from p in Post,
        where: [published: true],
        preload: [:tags],
        order_by: [desc: :published_date]

    Repo.all(query)
  end

  def get_post_by_slug(slug) do
    comments_query = from(c in Comment, where: c.approved == true, order_by: [asc: :inserted_at])

    Repo.get_by(Post, slug: slug)
    |> Repo.preload([:tags, comments: comments_query])
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

  def create_comment(params) do
    %Comment{}
    |> Comment.changeset(params)
    |> Repo.insert()
  end

  def get_comments_for_post(post_id) do
    from(c in Comment,
      where: c.post_id == ^post_id and c.approved == true,
      order_by: [asc: :inserted_at]
    )
    |> Repo.all()
  end

  def list_unapproved_comments() do
    from(c in Comment, where: c.approved == false, order_by: [desc: :inserted_at])
    |> Repo.all()
  end

  def approve_comment(comment_id) do
    Repo.get!(Comment, comment_id)
    |> Comment.changeset(%{approved: true})
    |> Repo.update()
  end

  def get_related_posts(post, limit \\ 3) do
    tag_names = Enum.map(post.tags, & &1.name)

    query =
      from p in Post,
        join: t in assoc(p, :tags),
        where: t.name in ^tag_names and p.id != ^post.id and p.published == true,
        preload: [:tags],
        group_by: p.id,
        order_by: [desc: fragment("COUNT(*)"), desc: :published_date],
        limit: ^limit

    Repo.all(query)
  end

  def get_latest_posts(limit \\ 3) do
    query =
      from p in Post,
        where: p.published == true,
        preload: [:tags],
        order_by: [desc: :published_date],
        limit: ^limit

    Repo.all(query)
  end
end
