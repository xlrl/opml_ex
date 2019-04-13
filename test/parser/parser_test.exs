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

    @xml """
    <body>
    <outline text="c1"/>
    <outline text="c2"/>
    </body>
    """
    test "two categories" do
      result = Parser.parse(@xml)

      assert result == {:ok, [{"c2", []}, {"c1", []}]}
    end

    @xml """
    <body>
    <outline text="c1">
    <outline text="f1.1" xmlUrl="x1.1" htmlUrl="h1.1"/>
    <outline text="f1.2" xmlUrl="x1.2" htmlUrl="h1.2"/>
    </outline>
    <outline text="c2">
    <outline text="f2.1" xmlUrl="x2.1" htmlUrl="h2.1"/>
    <outline text="f2.2" xmlUrl="x2.2" htmlUrl="h2.2"/>
    </outline>
    </body>
    """
    test "several categories and feeds" do
      result = Opml.parse(@xml)

      assert result == {:ok, [
                           {"c2", [{"f2.2", "x2.2", "h2.2"}, {"f2.1", "x2.1", "h2.1"}]},
                           {"c1", [{"f1.2", "x1.2", "h1.2"}, {"f1.1", "x1.1", "h1.1"}]}
                         ]}
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
