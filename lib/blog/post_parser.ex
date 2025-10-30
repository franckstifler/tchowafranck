defmodule Blog.PostParser do
  use Task

  def start_link(_) do
    Task.start_link(__MODULE__, :run, [])
  end

  def run() do
    app_dir = Application.app_dir(:blog)
    posts_location = "priv/posts/*.md"

    app_dir
    |> Path.join(posts_location)
    |> Path.wildcard()
    |> Stream.map(&read_file/1)
    |> Enum.to_list()
  end

  defp read_file(path) do
    [metadata, content] =
      path
      |> File.read!()
      |> String.split("---", trim: true)

    metadata =
      parse_metadata(metadata)
      |> put_slug()

    content = parse_content(content)

    Map.merge(metadata, content)
    |> Blog.insert_post()
  end

  defp parse_metadata(metadata) do
    metadata
    |> String.split("\n", trim: true)
    |> Enum.into(%{}, fn line ->
      [key, value] = String.split(line, ": ", trim: true)
      {String.to_atom(key), value}
    end)
  end

  defp parse_content(content) do
    content
    |> Earmark.as_html()
    |> case do
      {:ok, doc, _} -> %{content: doc}
      {:error, doc, errors} -> %{content: "#{doc} </br> #{errors}"}
    end
  end

  defp put_slug(metadata) do
    slug =
      metadata.title
      |> String.downcase()
      |> String.split(" ", trim: true)
      |> Enum.join("-")

    Map.put(metadata, :slug, slug)
  end
end
