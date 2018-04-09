# stormcrawlerfight
Benchmarking of StormCrawler with different versions, backends or alternative crawlers.

Create a link named 'seeds' to the seeds file of your choice.

With Storm installed, you can generate an uberjar:

``` sh
mvn clean package
```

then 

``` sh
storm jar target/storm-crawler-fight-2.0-SNAPSHOT.jar  org.apache.storm.flux.Flux --local es-crawler.flux
```

Replace '--local' with '--remote' to deploy it on a running Storm cluster.

