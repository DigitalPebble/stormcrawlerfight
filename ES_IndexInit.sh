# deletes and recreates a status index with a bespoke schema

echo "Deleting status index   "

curl -XDELETE 'http://localhost:9200/status/'

# http://localhost:9200/status/_mapping/status?pretty

echo ""
echo "Creating status index   "

curl -XPOST localhost:9200/status -d '
{
	"settings": {
		"index": {
			"number_of_shards": 32,
			"number_of_replicas": 0,
			"refresh_interval" : "5s"
		}
	},
	"mappings": {
		"status": {
			"dynamic_templates": [{
				"metadata": {
					"path_match": "metadata.*",
					"match_mapping_type": "string",
					"mapping": {
						"type": "string",
						"index": "not_analyzed"
					}
				}
			}],
			"_source": {
				"enabled": true
			},
			"_all": {
				"enabled": false
			},
			"properties": {
				"nextFetchDate": {
					"type": "date",
					"format": "dateOptionalTime"
				},
				"status": {
					"type": "string",
					"index": "not_analyzed"
				},
				"url": {
					"type": "string",
					"index": "not_analyzed"
				}
			}
		}
	}
}'

# deletes and recreates a status index with a bespoke schema

echo ""
echo "Deleting metrics index   "

curl -XDELETE 'http://localhost:9200/metrics/'

echo ""
echo "Creating metrics index"

# http://localhost:9200/metrics/_mapping/status?pretty
curl -XPOST localhost:9200/_template/storm-metrics-template -d '
{
  "template": "metrics*",
  "settings": {
    "index": {
      "number_of_shards": 1,
      "refresh_interval": "5s"
    },
    "number_of_replicas" : 0
  },
  "mappings": {
    "datapoint": {
      "_all":            { "enabled": false },
      "_source":         { "enabled": true },
      "properties": {
          "name": {
            "type": "string",
            "index": "not_analyzed"
          },
          "srcComponentId": {
            "type": "string",
            "index": "not_analyzed"
          },
          "srcTaskId": {
            "type": "long"
          },
          "srcWorkerHost": {
            "type": "string",
            "index": "not_analyzed"
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

