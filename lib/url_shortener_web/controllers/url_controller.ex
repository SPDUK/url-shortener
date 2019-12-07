defmodule UrlShortenerWeb.UrlController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Shortener
  alias UrlShortener.Shortener.Url
  alias Validation
  import Ecto

  action_fallback UrlShortenerWeb.FallbackController

  def index(conn, _params) do
    urls = Shortener.list_urls()
    render(conn, "index.json", urls: urls)
  end

  # TODO: clean this up :( I forget how to nested pattern match on a map
  def create(conn, %{"url" => url_params}) do
    originalUrl = Map.get(url_params, "originalUrl")
    shortUrl = Map.get(url_params, "shortUrl")

    with {:ok, _} <- Validation.validate_uri(originalUrl) do
      uuid = Ecto.UUID.generate()

      opts =
        url_params
        |> Map.put("urlCode", uuid)
        |> Map.put("shortUrl", "#{shortUrl}/#{uuid}")

      with {:ok, %Url{} = url} <- Shortener.create_url(opts) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.url_path(conn, :show, url))
        |> render("show.json", url: url)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    case Shortener.get_url(id) do
      nil -> redirect(conn, external: "https://www.google.com")
      url -> redirect(conn, external: url.originalUrl)
    end
  end

  def update(conn, %{"id" => id, "url" => url_params}) do
    url = Shortener.get_url(id)

    with {:ok, %Url{} = url} <- Shortener.update_url(url, url_params) do
      render(conn, "show.json", url: url)
    end
  end

  def delete(conn, %{"id" => id}) do
    url = Shortener.get_url(id)

    with {:ok, %Url{}} <- Shortener.delete_url(url) do
      send_resp(conn, :no_content, "")
    end
  end
end
