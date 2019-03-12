defmodule Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :content, :string
    field :slug, :string
    field :published_date, :naive_datetime
    field :published, :boolean
    field :blurb, :string

    many_to_many(:tags, Blog.Tag, join_through: "posts_tags", on_replace: :delete)
    timestamps()
  end

  @fields [:title, :blurb, :slug, :content, :published_date, :published]

  def changeset(post, attrs) do
    post
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> unique_constraint(:slug, message: "slug #{attrs.slug} already taken")
  end
end
