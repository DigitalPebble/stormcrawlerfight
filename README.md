# stormcrawlerfight
Comparison between ES and Cassandra backends for StormCrawler


With Storm installed, you can generate an uberjar:

``` sh
mvn clean package
```

and then use the following command to inject URLs into the topology

``` sh
storm jar target/storm-crawler-fight-1.0-SNAPSHOT.jar  org.apache.storm.flux.Flux --local injector.flux
```

then 

``` sh
storm jar target/storm-crawler-fight-1.0-SNAPSHOT.jar  org.apache.storm.flux.Flux --local crawler.flux
```

Replace '--local' with '--remote' to deploy it on a running Storm cluster.



# Cassandra

```
CREATE KEYSPACE IF NOT EXISTS stormcrawler WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 1};

DROP TABLE stormcrawler.webpage;

CREATE TABLE stormcrawler.webpage (url text, status text, next_fetch_date timestamp, hostname text, metadata text, PRIMARY KEY (hostname, url));

INSERT INTO stormcrawler.webpage (url, status, next_fetch_date, hostname, metadata) VALUES ('http://www.lemonde.fr', 'DISCOVERED', '2016-11-28 16:18:24', 'www.lemonde.fr', '') IF NOT EXISTS;
```

The injector.flux file can be used as a replacement for the last step. 
