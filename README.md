# stormcrawlerfight
Benchmarking of StormCrawler with different versions, backends or alternative crawlers.

With Storm installed, you can generate an uberjar:

``` sh
mvn clean package
```

and then use the following command to inject URLs into the topology

``` sh
storm jar target/storm-crawler-fight-2.0-SNAPSHOT.jar  org.apache.storm.flux.Flux --local sql-injector.flux -sleep 999999
```

then 

``` sh
storm jar target/storm-crawler-fight-2.0-SNAPSHOT.jar  org.apache.storm.flux.Flux --local sql-crawler.flux -sleep 999999
```

Replace '--local' with '--remote' to deploy it on a running Storm cluster.

