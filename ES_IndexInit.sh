# deletes and recreates a status index with a bespoke schema

curl -s -XDELETE 'http://localhost:9200/status/' >  /dev/null

echo "Deleted status index"

# http://localhost:9200/status/_mapping/status?pretty

echo "Creating status index with mapping"

curl -XPUT localhost:9200/status -H 'Content-Type: application/json' -d '
{
	"settings": {
		"index": {
			"number_of_shards": 100,
			"number_of_replicas": 0,
			"refresh_interval": "5s"
		}
	},
	"mappings": {
		"status": {
			"dynamic_templates": [{
				"metadata": {
					"path_match": "metadata.*",
					"match_mapping_type": "string",
					"mapping": {
						"type": "keyword"
					}
				}
			}],
			"_source": {
				"enabled": true
			},
			"properties": {
				"nextFetchDate": {
					"type": "date",
					"format": "dateOptionalTime"
				},
				"status": {
					"type": "keyword"
				},
				"url": {
					"type": "keyword"
				}
			}
		}
	}
}'

# deletes and recreates a status index with a bespoke schema

curl -s -XDELETE 'http://localhost:9200/metrics*/' >  /dev/null

echo ""
echo "Deleted metrics index"

echo "Creating metrics index with mapping"

# http://localhost:9200/metrics/_mapping/status?pretty
curl -s -XPOST localhost:9200/_template/storm-metrics-template -H 'Content-Type: application/json' -d '
{
  "template": "metrics*",
  "settings": {
    "index": {
      "number_of_shards": 1,
      "refresh_interval": "30s"
    },
    "number_of_replicas" : 0
  },
  "mappings": {
    "datapoint": {
      "_source":         { "enabled": true },
      "properties": {
          "name": {
            "type": "keyword"
          },
          "srcComponentId": {
            "type": "keyword"
          },
          "srcTaskId": {
            "type": "long"
          },
          "srcWorkerHost": {
            "type": "keyword"
          },
          "srcWorkerPort": {
            "type": "long"
          },
          "timestamp": {
            "type": "date",
            "format": "dateOptionalTime"
          },
          "value": {
            "type": "double"
          }
      }
    }
  }
}'

