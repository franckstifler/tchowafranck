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
    field :language, :string, default: "en"
    field :translation_key, :string

    many_to_many(:tags, Blog.Tag, join_through: "posts_tags", on_replace: :delete)
    has_many :comments, Blog.Comment
    timestamps()
  end

  @fields [
    :title,
    :blurb,
    :slug,
    :content,
    :published_date,
    :published,
    :language,
    :translation_key
  ]
  @required_fields [:title, :blurb, :slug, :content, :published_date, :published, :language]

  def changeset(post, attrs) do
    post
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:slug, message: "slug #{attrs.slug} already taken")
  end
end
