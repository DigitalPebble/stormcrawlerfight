# stormcrawlerfight
Benchmarking of StormCrawler with different versions, backends or alternative crawlers.

With Storm installed, you can generate an uberjar:

``` sh
mvn clean package
```

then 

``` sh
storm jar target/storm-crawler-fight-1.0-SNAPSHOT.jar  org.apache.storm.flux.Flux --local crawler.flux
```

Replace '--local' with '--remote' to deploy it on a running Storm cluster.

