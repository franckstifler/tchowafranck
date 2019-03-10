defmodule Blog.Repo.Migrations.CreatePostTable do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string, null: false
      add :content, :text, null: false
      add :slug, :string, null: false
      add :published_date, :naive_datetime
      add :published, :boolean, default: true

      timestamps()
    end

    create unique_index(:posts, [:slug])
  end
end
