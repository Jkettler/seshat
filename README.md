# Readme

### Silvercar Metric Service
#### A metric logging service that sums metrics by time window for the most recent hour

### 1. Dependencies
1. Docker Compose
2. Ruby (I used 2.6.2), bundler 


### 2. Build/Run 
To run locally, just run `scripts/build.sh` from a console in the project directory.  
The script calls `bundle install` and `docker-compose up` to build/run the redis image and then `ruby seshat.rb` to start the server.  
There are also scripts in that folder to call the API's `post` and `sum` endpoints, and to run tests.  
- `scripts/post.sh 15`
- `scripts/sum.sh`
- `scripts/run_tests.sh`

### 3. Note to whoever is reviewing this

There's another markdown file in this directory called `notes.md` that contain some of the notes and thoughts I had during the research portion of this project.
I looked at quite a few different technologies before settling on Redis' Timeseries module, which not only seemed like the right tool for the job, but also didn't require a lot of configuration out of the box. 

I also wanted to take a shot at the Repository pattern that I learned about for the first time when I was in the office on Thursday.  

In the context of this one-off project, both redis and repository patterns are a bit much, but I enjoy learning/trying new things and one-off projects are the perfect time to do so.

This took me about a day to do, with a good chunk of that time being research.
 
I had a lot of fun with this and I look forward to y'all's feedback!  

Thanks,  
Jimmy

