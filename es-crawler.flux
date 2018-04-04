name: "crawler"

includes:
    - resource: true
      file: "/crawler-default.yaml"
      override: false

    - resource: false
      file: "crawler-conf.yaml"
      override: true

    - resource: false
      file: "es-conf.yaml"
      override: true

spouts:
  - id: "spout"
    className: "com.digitalpebble.stormcrawler.elasticsearch.persistence.AggregationSpout"
    parallelism: 100

bolts:
  - id: "partitioner"
    className: "com.digitalpebble.stormcrawler.bolt.URLPartitionerBolt"
    parallelism: 2
  - id: "fetcher"
    className: "com.digitalpebble.stormcrawler.bolt.FetcherBolt"
    parallelism: 2
  - id: "sitemap"
    className: "com.digitalpebble.stormcrawler.bolt.SiteMapParserBolt"
    parallelism: 2
  - id: "feed"
    className: "com.digitalpebble.stormcrawler.bolt.FeedParserBolt"
    parallelism: 2
  - id: "parse"
    className: "com.digitalpebble.stormcrawler.bolt.JSoupParserBolt"
    parallelism: 4
  - id: "index"
    className: "com.digitalpebble.stormcrawler.indexing.DummyIndexer"
    parallelism: 2
  - id: "status"
    className: "com.digitalpebble.stormcrawler.elasticsearch.persistence.StatusUpdaterBolt"
    parallelism: 4
  - id: "status_metrics"
    className: "com.digitalpebble.stormcrawler.elasticsearch.metrics.StatusMetricsBolt"
    parallelism: 2

streams:
  - from: "spout"
    to: "partitioner"
    grouping:
      type: SHUFFLE

  - from: "spout"
    to: "status_metrics"
    grouping:
      type: SHUFFLE     

  - from: "partitioner"
    to: "fetcher"
    grouping:
      type: FIELDS
      args: ["key"]

  - from: "fetcher"
    to: "sitemap"
    grouping:
      type: LOCAL_OR_SHUFFLE

  - from: "sitemap"
    to: "feed"
    grouping:
      type: LOCAL_OR_SHUFFLE

  - from: "feed"
    to: "parse"
    grouping:
      type: LOCAL_OR_SHUFFLE

  - from: "parse"
    to: "index"
    grouping:
      type: LOCAL_OR_SHUFFLE

  - from: "fetcher"
    to: "status"
    grouping:
      type: FIELDS
      args: ["url"]
      streamId: "status"

  - from: "sitemap"
    to: "status"
    grouping:
      type: FIELDS
      args: ["url"]
      streamId: "status"

  - from: "parse"
    to: "status"
    grouping:
      type: FIELDS
      args: ["url"]
      streamId: "status"

  - from: "index"
    to: "status"
    grouping:
      type: FIELDS
      args: ["url"]
      streamId: "status"
