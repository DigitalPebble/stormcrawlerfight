# stormcrawlerfight
Benchmarking of StormCrawler with different versions, backends or alternative crawlers.

With Storm installed, you can generate an uberjar:

``` sh
mvn clean package
```

and then use the following command to inject URLs into the topology

``` sh
storm jar target/storm-crawler-fight-2.0-SNAPSHOT.jar  org.apache.storm.flux.Flux --local es-injector.flux
```

then 

``` sh
storm jar target/storm-crawler-fight-2.0-SNAPSHOT.jar  org.apache.storm.flux.Flux --local es-crawler.flux
```

Replace '--local' with '--remote' to deploy it on a running Storm cluster.

