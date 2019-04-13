defmodule Opml.Parser do
  @moduledoc """
  This is the parser for opml documents.

  See: `parse/1`
  """

  @doc false
  def parse("") do
    []
  end

  def parse(doc) do
    {result, %{categories: categories}, _} = :erlsom.parse_sax(doc, nil, &parse_event/2)
    # IO.inspect(categories)
    {result, categories}
  end

  defp parse_event(:startDocument, _acc) do
    %{categories: []}
  end

  defp parse_event(:endDocument, {acc}), do: acc

  defp parse_event({:startElement, _, 'outline', _, attrs}, acc) do
    start_outline(attrs, acc)
  end

  defp parse_event({:endElement, _, 'outline', _}, acc) do
    end_outline(acc)
    # IO.inspect(acc)
  end

  defp parse_event(_evt, acc) do
    # IO.inspect(evt)
    # IO.inspect(acc)
    acc
  end

  defp start_outline(attrs, %{category: _} = acc) do
    text = find_attr(attrs, 'text')
    xml_url = find_attr(attrs, 'xmlUrl')
    html_url = find_attr(attrs, 'htmlUrl')
    feed = {text, xml_url, html_url}

    acc
    |> Map.put(:feed, feed)
  end

  defp start_outline(attrs, %{} = acc) do
    text = find_attr(attrs, 'text')

    acc
    |> Map.put(:category, {text, []})
  end

  defp end_outline(%{feed: feed, category: {category, feeds}} = acc) do
    feeds = [feed | feeds]

    acc
    |> Map.put(:category, {category, feeds})
    |> Map.drop([:feed])
  end

  defp end_outline(%{category: category, categories: categories} = acc) do
    categories = [category | categories]

    acc
    |> Map.drop([:category])
    |> Map.put(:categories, categories)
  end

  @doc """
  Tries to find `name`` in `attrs`.

  Returns `nil` if not found.

  Remark: charlists are converted to strings

  ## Examples

      iex> Opml.Parser.find_attr([], 'name')
      :nil

      iex> Opml.Parser.find_attr([{:attribute, 'key', :dont, :care, 'value'}], 'key')
      "value"
  """
  def find_attr([] = _attrs, _name), do: nil
  def find_attr([{:attribute, name, _, _, value} | _], name), do: convert_value(value)
  def find_attr([_ | t], name), do: find_attr(t, name)

  @doc """
  Converts charlist in `v` to a string and returns everything else "as is".

  ## Examples

      iex> Opml.Parser.convert_value(nil)
      :nil

      iex> Opml.Parser.convert_value(10)
      10

      iex> Opml.Parser.convert_value('value')
      "value"

      iex> Opml.Parser.convert_value("value")
      "value"
  """
  def convert_value([_ | _] = v), do: List.to_string(v)
  def convert_value(v), do: v
end
