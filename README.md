# stormcrawlerfight
Comparison between StormES and Nutch

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

