defmodule UrlShortener.Shortener.Url do
  use Ecto.Schema
  import Ecto.Changeset

  schema "urls" do
    field :originalUrl, :string
    field :shortUrl, :string
    field :urlCode, :string

    timestamps()
  end

  @doc false
  def changeset(url, attrs) do
    url
    |> cast(attrs, [:originalUrl, :shortUrl, :urlCode])
    |> validate_required([:originalUrl, :shortUrl, :urlCode])
  end
end
