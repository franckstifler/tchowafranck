defmodule Blog.Repo.Migrations.AddBlurbToPost do
  use Ecto.Migration

  def change do
    alter(table(:posts)) do
      add(:blurb, :string, null: false)
    end
  end
end
