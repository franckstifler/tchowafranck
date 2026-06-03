defmodule Blog.Repo.Migrations.AddLanguageMetadataToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :language, :string, null: false, default: "en"
      add :translation_key, :string
    end

    create index(:posts, [:translation_key])
  end
end
