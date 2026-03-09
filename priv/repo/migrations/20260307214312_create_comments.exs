defmodule Blog.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :author, :string, null: false
      add :email, :string, null: false
      add :content, :text, null: false
      add :approved, :boolean, default: false
      add :post_id, references(:posts, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:comments, [:post_id])
    create index(:comments, [:approved])
  end
end
