defmodule BlogWeb.FeedXML do
  @moduledoc """
  Renders the per-language RSS 2.0 feed.

  Exposes `render/1`, compiled from `feed_xml/index.xml.eex`, which expects an
  `assigns` map with `:language` and `:posts`.
  """
  use BlogWeb, :verified_routes

  import BlogWeb.XMLHelpers

  require EEx

  EEx.function_from_file(
    :def,
    :render,
    Path.join(__DIR__, "feed_xml/index.xml.eex"),
    [:assigns]
  )

  @doc "Absolute URL of a post."
  def post_url(post), do: url(~p"/posts/#{post.slug}")

  @doc "Absolute URL of the feed for a given language."
  def feed_url(language), do: url(~p"/feed/#{language}")

  @doc "Absolute URL of the site root."
  def site_url, do: url(~p"/")
end
