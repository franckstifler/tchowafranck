defmodule BlogWeb.XMLHelpers do
  @moduledoc """
  Shared helpers for rendering the RSS feed and sitemap XML documents.
  """

  @doc """
  Builds a plain-text excerpt from a post's rendered HTML `content`.

  Strips HTML tags, collapses whitespace, and truncates to `max` characters on a
  word boundary, appending an ellipsis when truncated. Falls back to `blurb` when
  the content is empty.
  """
  def excerpt(content, blurb, max \\ 255)

  def excerpt(content, blurb, max) when is_binary(content) do
    text =
      content
      |> strip_tags()
      |> collapse_whitespace()

    case text do
      "" -> to_string(blurb)
      text -> truncate(text, max)
    end
  end

  def excerpt(_content, blurb, _max), do: to_string(blurb)

  defp strip_tags(html) do
    html
    |> String.replace(~r/<[^>]*>/, " ")
    |> decode_basic_entities()
  end

  defp decode_basic_entities(text) do
    text
    |> String.replace("&amp;", "&")
    |> String.replace("&lt;", "<")
    |> String.replace("&gt;", ">")
    |> String.replace("&quot;", "\"")
    |> String.replace("&#39;", "'")
  end

  defp collapse_whitespace(text) do
    text
    |> String.replace(~r/\s+/, " ")
    |> String.trim()
  end

  defp truncate(text, max) do
    if String.length(text) <= max do
      text
    else
      text
      |> String.slice(0, max)
      |> String.replace(~r/\s+\S*$/, "")
      |> Kernel.<>("…")
    end
  end

  @doc "Escapes a string for safe inclusion in XML text/attribute content."
  def xml_escape(value) do
    value
    |> to_string()
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
    |> String.replace("\"", "&quot;")
    |> String.replace("'", "&apos;")
  end

  @doc "Formats a `NaiveDateTime` (assumed UTC) as an RFC-822 date for RSS `pubDate`."
  def rfc822(%NaiveDateTime{} = naive) do
    naive
    |> DateTime.from_naive!("Etc/UTC")
    |> Timex.format!("{RFC822}")
  end

  @doc "Formats a `NaiveDateTime` as a W3C/ISO-8601 date for sitemap `lastmod`."
  def w3c_date(%NaiveDateTime{} = naive) do
    NaiveDateTime.to_date(naive) |> Date.to_iso8601()
  end
end
