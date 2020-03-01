# Notes

### Planning:
#### Simplest implementation: 
request -> sinatra \
-> POST -> RDBMS store key, value, created_at\
-> GET -> RDBMS `select value where created_at > Time.now - 1.hour` -> Array.sum
 
Pros: simple\
Cons:
- doesn't feel like best tool for the job
- concurrency issues?
- no cache 
- query for every request 
- probably wouldn't work for persistent connection (e.g. websockets)

# Research:
## AWS
- AWS
    - dynamodb (TTL) 
    - lambda
    - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/bp-time-series.html
    - aws-sdk-ruby-record gem
    
- Time series dbs 
    - https://en.wikipedia.org/wiki/Time_series_database
    - https://docs.timescale.com/latest/introduction/time-series-data
    - https://www.influxdata.com/
    
- Redis
    - redis(TTL) https://redis.io/commands/expire
    - redis time series https://oss.redislabs.com/redistimeseries/
    
- sinatra
    - http://sinatrarb.com/intro.html

- repository pattern
    - Definitely not necessary for this small project, but interested in learning
    
- ETags
    - https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/ETag


## wants:
- dynamic models (reqs unclear, would ask for clarification irl, but fun challenge for now)
- time window flexibility (1 hour is arbitrary)
- dockerized

concerns:
- public or private api? how much to trust user data? (default: never trust client data)


# Dev 
~~--endpoint-url http://localhost:8000~~  
~~aws dynamodb update-time-to-live --table-name ActiveVisitors --time-to-live-specification "Enabled=true, AttributeName=ttl"~~   
~~aws dynamodb describe-time-to-live --table-name ActiveVisitors --endpoint-url http://localhost:8000~~  
1 hr = 3600000 ms  
http -f POST localhost:4567/metrics/active_visitors value=5    
http GET localhost:4567/metrics/active_visitors/sum 
