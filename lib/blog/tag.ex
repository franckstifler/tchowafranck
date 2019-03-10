defmodule Blog.Tag do
  use Ecto.Schema

  schema "tags" do
    field :name, :string

    # belongs_to(:post, Blog.Post)
  end
end
