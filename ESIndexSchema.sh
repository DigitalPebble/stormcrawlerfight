curl -s -XDELETE 'http://localhost:9200/content/' >  /dev/null
 echo ""
echo "Deleted content index"
 echo "Creating content index with mapping"
 curl -s -XPUT localhost:9200/content -H 'Content-Type: application/json' -d '
{
	"settings": {
		"index": {
			"number_of_shards": 5,
			"number_of_replicas": 1,
			"refresh_interval": "60s"
		}
	},
	"mappings": {
		"doc": {
			"_source": {
				"enabled": false
			},
			"properties": {
				"content": {
					"type": "text",
					"index": "true"
				},
				"domain": {
					"type": "keyword",
					"index": "true",
					"store": true
				},
				"keywords": {
					"type": "keyword",
					"index": "true",
					"store": true
				},
				"description": {
					"type": "text",
					"index": "true",
					"store": true
				},
				"title": {
					"type": "text",
					"index": "true",
					"store": true
				},
				"url": {
					"type": "keyword",
					"index": "false",
					"store": true
				}
			}
		}
	}
}'
