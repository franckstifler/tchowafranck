defmodule BlogWeb.PageView do
  use BlogWeb, :view

  def format_date(date) do
    Timex.today()
    |> Timex.diff(date, :days)
    |> format_to_text(date)
  end

  defp format_to_text(days, _) when days == 0, do: "Today"
  defp format_to_text(days, _) when days == 1, do: "Yesterday"
  defp format_to_text(days, _) when days < 30, do: "#{days} days ago"
  defp format_to_text(_, date), do: Timex.format!(date, "{D} {Mshort} {YYYY}")
end
