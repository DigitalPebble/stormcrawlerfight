name: "injector"

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

config:
    es.status.bulkActions: 100

components:
  - id: "scheme"
    className: "com.digitalpebble.stormcrawler.util.StringTabScheme"
    constructorArgs:
      - DISCOVERED

spouts:
  - id: "spout"
    className: "com.digitalpebble.stormcrawler.spout.FileSpout"
    parallelism: 1
    constructorArgs:
      - "."
      - "top1K2016.txt"
      - ref: "scheme"

bolts:
  - id: "status"
    className: "com.digitalpebble.stormcrawler.elasticsearch.persistence.StatusUpdaterBolt"
    parallelism: 1

streams:
  - from: "spout"
    to: "status"
    grouping:
      type: FIELDS
      args: ["url"]
