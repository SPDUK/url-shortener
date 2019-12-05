defmodule UrlShortenerWeb.UrlController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Shortener
  alias UrlShortener.Shortener.Url

  action_fallback UrlShortenerWeb.FallbackController

  def index(conn, _params) do
    urls = Shortener.list_urls()
    render(conn, "index.json", urls: urls)
  end

  def create(conn, %{"url" => url_params}) do
    with {:ok, %Url{} = url} <- Shortener.create_url(url_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.url_path(conn, :show, url))
      |> render("show.json", url: url)
    end
  end

  def show(conn, %{"id" => id}) do
    url = Shortener.get_url!(id)
    render(conn, "show.json", url: url)
  end

  def update(conn, %{"id" => id, "url" => url_params}) do
    url = Shortener.get_url!(id)

    with {:ok, %Url{} = url} <- Shortener.update_url(url, url_params) do
      render(conn, "show.json", url: url)
    end
  end

  def delete(conn, %{"id" => id}) do
    url = Shortener.get_url!(id)

    with {:ok, %Url{}} <- Shortener.delete_url(url) do
      send_resp(conn, :no_content, "")
    end
  end
end
