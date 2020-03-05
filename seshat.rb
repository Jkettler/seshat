require 'redis'
require 'sinatra/base'
require_relative 'modules/redis_client'
require_relative 'helpers/api_helpers'
require_relative 'models/metric'

Dir[File.join(__dir__, 'repositories', '*.rb')].each { |file| require file }

# https://en.wikipedia.org/wiki/Seshat
class Seshat < Sinatra::Base
  include RedisClient

  before do
    @client = RedisClient.init
  end

  post '/metrics/:key' do
    success = ->() { [200, JSON.generate({})] }
    error = ->(val) { halt 400, "Bad value or unknown key. value: #{val}, key: #{params['key']}" }
    begin
      metric = Metric.new(@client, params['key'])
    rescue RuntimeError, 'Unknown Metric'
      nil
    end

    if metric
      metric.new_entity(params['value'])
      success.call
    else
      error.call(params['value'])
    end
  end

  get '/metrics/:key/sum' do
    success = ->(sum) { [200, JSON.generate({value: sum})] }
    error = ->() { halt 400, "Bad key or no data to get. Try posting first" }

    begin
      metric = Metric.new(@client, params['key'])
    rescue RuntimeError, 'Unknown Metric'
      nil
    end

    metric ? success.call(metric.sum_vals) : error.call
  end

  # run Sinatra server
  at_exit { Seshat.run! } unless settings.test?
end
