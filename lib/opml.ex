defmodule Opml do
  @moduledoc """
  Parser for _opml_ files.
  Documentation for Opml.
  """

  @doc """
  Parse an opml document.

  ## Examples

      iex> Opml.parse("<opml><body><outline text='Category'><outline text='Feed' xmlUrl='foo'/></outline></body></opml>")
      {:ok, [{"Category", [{"Feed", "foo", nil}]}]}

  """
  defdelegate parse(doc), to: Opml.Parser
end
