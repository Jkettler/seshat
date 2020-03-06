require 'sinatra/base'
require_relative 'modules/redis_client'
require_relative 'models/metric'

# https://en.wikipedia.org/wiki/Seshat
class Seshat < Sinatra::Base
  include RedisClient

  before do
    @client = RedisClient.init
  end

  post '/metrics/:key' do
    key = params['key']
    value = params['value']

    success = ->() { [200, JSON.generate({})] }
    error = ->(val) { halt 400, "Bad value or unknown key!  key: #{key}, value: #{val}" }

    metric = begin
      Metric.new(@client, key).new_entity(value)
    rescue ArgumentError
      nil
    end

    metric ? success.call : error.call(value)
  end

  get '/metrics/:key/sum' do
    key = params['key']

    success = ->(sum) { [200, JSON.generate({value: sum})] }
    error = ->() { halt 400, "Unknown Key! key: #{key}" }

    sum = begin
      Metric.new(@client, key).sum_vals
    rescue ArgumentError
      nil
    end

    sum ? success.call(sum) : error.call
  end

  # run Sinatra server
  at_exit { Seshat.run! } unless settings.test?
end
