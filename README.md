# opml_ex

This is an Elixir parser for [http://dev.opml.org/](OPML) files/data. OPML files can be used to transport RSS feed data between different RSS feed readers.

## Prerequisites

This library needs:
* Elixir >= 1.8.1
* Erlang >= 21

## Installation

The package can be installed by adding `opml_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:opml_ex, git: "https://github.com/xlrl/opml_ex.git", tag: "0.1.0"}
  ]
```

Install the library by running:

```shell
$ mix deps.get
```

## Usage

Read the OPML document:

```elixir
iex> doc = File.read!("feeds.opml")
<?xml version="1.0" encoding="utf-8"?>
<opml version="1.0">
  <head>
    <dateCreated>Thu, 04 Apr 2019 17:33:49 +0000</dateCreated>
    <title>Some RSS Feed Export</title>
  </head>
  <body>
    <outline text="My Category">
      <outline type="rss" text="My Feed" xmlUrl="http://feed.org/index.xml" htmlUrl="http://feed.org/index.html"/>
    </outline>
  </body>
</opml>
```

Pass the document to `opml_ex`:

```elixir
iex> opml = Opml.parse(doc)
{:ok, [{"My Category", [{"My Feed", ""http://feed.org/index.xml", "http://feed.org/index.html}]}]}
```

The result is map list of tuples with categories.

Each category contains a list of feeds.

## Build With
* [https://hex.pm/packages/erlsom](erlsom)

## Versioning

We use [http://semver.org/](semver) for versioning. For the versions available, see the tags on this repository.

## Authors

* Alexander Mueller - initial work

## License

This project is licensed under the MIT license - see the [LICENSE](LICENSE) file for details.
