defmodule BlogWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use BlogWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header>
      <nav>
        <h1>Franck Tchowa</h1>
        <ul>
          <li><a href="/">Home</a></li>
          <li><a target="_blank" href="https://github.com/franckstifler">GitHub</a></li>
          <li><a href="/about">About Me</a></li>
          <li><a href="/contact">Contact Me</a></li>
        </ul>
      </nav>
    </header>

    <main class="container">
      {render_slot(@inner_block)}
    </main>
    """
  end
end
