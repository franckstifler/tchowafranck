defmodule BlogWeb.SitemapXML do
  @moduledoc """
  Renders the XML sitemap.

  Exposes `render/1`, compiled from `sitemap_xml/index.xml.eex`, which expects an
  `assigns` map with `:posts`, `:tags`, and `:translations` (a map of
  `translation_key => [posts]` used to emit `hreflang` alternates).
  """
  use BlogWeb, :verified_routes

  import BlogWeb.XMLHelpers

  require EEx

  EEx.function_from_file(
    :def,
    :render,
    Path.join(__DIR__, "sitemap_xml/index.xml.eex"),
    [:assigns]
  )

  def post_url(post), do: url(~p"/posts/#{post.slug}")
  def tag_url(tag), do: url(~p"/tags/#{tag}")

  @doc """
  Returns the list of translation alternates for a post as `{language, url}`
  tuples (including the post itself), or `[]` when it has no translation group.
  """
  def alternates(post, translations) do
    case post.translation_key do
      key when key in [nil, ""] ->
        []

      key ->
        translations
        |> Map.get(key, [])
        |> Enum.map(&{&1.language, post_url(&1)})
    end
  end
end
