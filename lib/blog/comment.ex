defmodule Blog.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :author, :string
    field :email, :string
    field :content, :string
    field :approved, :boolean, default: false

    belongs_to :post, Blog.Post
    timestamps()
  end

  @fields [:author, :email, :content, :post_id, :approved]

  def changeset(comment, attrs) do
    comment
    |> cast(attrs, @fields)
    |> validate_required([:author, :email, :content, :post_id])
    |> validate_length(:author, min: 2, max: 100)
    |> validate_length(:content, min: 3, max: 1000)
    |> validate_format(:email, ~r/@/)
    |> assoc_constraint(:post)
  end
end
