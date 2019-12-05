defmodule UrlShortenerWeb.UrlView do
  use UrlShortenerWeb, :view
  alias UrlShortenerWeb.UrlView

  def render("index.json", %{urls: urls}) do
    %{data: render_many(urls, UrlView, "url.json")}
  end

  def render("show.json", %{url: url}) do
    %{data: render_one(url, UrlView, "url.json")}
  end

  def render("url.json", %{url: url}) do
    %{id: url.id,
      originalUrl: url.originalUrl,
      shortUrl: url.shortUrl,
      urlCode: url.urlCode}
  end
end
