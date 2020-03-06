# Readme

### Seshat Metric Service (https://en.wikipedia.org/wiki/Seshat)
### Description:
A metric logging service that sums metrics by time window for the most recent hour using pure Ruby and Redis Timeseries.  
Effort was made to keep the requirements minimal and the code clean and performant.


### 1. Dependencies
- Docker Compose
- Ruby (I used 2.6.2)
- bundler 

### 2. Build/Run 
To run locally, just run `scripts/build.sh` from a console in the project directory.  
The script calls `bundle install` and `docker-compose up` to build/run the redis image and then `ruby seshat.rb` to start the server.  
There are also scripts in that folder to call the API's `post` and `sum` endpoints, and to run tests.  
- `scripts/post.sh active_visitors 15`
- `scripts/sum.sh active_visitors`
- `scripts/run_tests.sh`

### 3. Other Info
Data persists as long as the Redis container is running. Restarting it will wipe everything.  
You can easily make more metrics available by adding the desired endpoint to the `KEY_WHITELIST` constant in `models/metric.rb`  

### 4. Sample Input/Output
```
$ curl localhost:4567/metrics/some_other_metric/sum
{"value":"0"}
$ curl -X POST -d "value=15" localhost:4567/metrics/some_other_metric
{}
$ curl localhost:4567/metrics/some_other_metric/sum
{"value":"15"}
$ curl -X POST -d "value=5" localhost:4567/metrics/some_other_metric
{}
$ curl localhost:4567/metrics/some_other_metric/sum
{"value":"20"}
.
.
# wait an hour
.
.
$ curl localhost:4567/metrics/some_other_metric/sum
{"value":"0"}
```
