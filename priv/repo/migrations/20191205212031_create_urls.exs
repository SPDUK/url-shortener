defmodule UrlShortener.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls) do
      add :originalUrl, :string
      add :shortUrl, :string
      add :urlCode, :string

      timestamps()
    end
  end
end
