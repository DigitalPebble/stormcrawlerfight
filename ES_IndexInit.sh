ESHOST="http://localhost:9200"
ESCREDENTIALS="-u elastic:passwordhere"

# deletes and recreates a status index with a bespoke schema

curl $ESCREDENTIALS -s -XDELETE "$ESHOST/status/" >  /dev/null

echo "Deleted status index"

# http://localhost:9200/status/_mapping/status?pretty

echo "Creating status index with mapping"

curl $ESCREDENTIALS -s -XPUT $ESHOST/status -H 'Content-Type: application/json' -d '
{
	"settings": {
		"index": {
			"number_of_shards": 10,
			"number_of_replicas": 0,
			"refresh_interval": "1s"
		}
	},
	"mappings": {
			"dynamic_templates": [{
				"metadata": {
					"path_match": "metadata.*",
					"match_mapping_type": "string",
					"mapping": {
						"type": "keyword",
						"index": false,
						"doc_values": false
					}
				}
			}],
			"_source": {
				"enabled": true
			},
			"_field_names": {
				"enabled": false
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
					"type": "keyword",
					"index": false
				},
                                "key": {
                                        "type": "keyword",
                                        "index": true
                                }
			}
	
	}
}'

# deletes and recreates a status index with a bespoke schema

curl $ESCREDENTIALS -s -XDELETE "$ESHOST/metrics*/" >  /dev/null

echo ""
echo "Deleted metrics index"

echo "Creating metrics index with mapping"

# http://localhost:9200/metrics/_mapping/status?pretty
curl $ESCREDENTIALS -s -XPOST $ESHOST/_template/storm-metrics-template -H 'Content-Type: application/json' -d '
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
}'

