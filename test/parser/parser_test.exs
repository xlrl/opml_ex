defmodule Opml.ParserTest do
  use ExUnit.Case
  doctest Opml.Parser
  alias Opml.Parser

  describe "parse/1" do
    test "parse empty" do
      assert [] = Parser.parse("")
    end

    @xml """
    <outline text="category"/>
    """
    test "single empty category" do
      assert Parser.parse(@xml) == {:ok, [{"category", []}]}
    end

    @xml """
    <outline text="category">
    <outline text="feed" xmlUrl="xmlUrl" htmlUrl="htmlUrl"/>
    </outline>
    """

    test "category with one feed" do
      result = Parser.parse(@xml)

      assert result == {:ok, [{"category", [{"feed", "xmlUrl", "htmlUrl"}]}]}
    end
  end

  describe "convert_value/1" do
    test "nil" do
      assert Parser.convert_value(nil) == nil
    end

    test "charlist converts to string" do
      assert Parser.convert_value('hello') == "hello"
    end
  end
end
