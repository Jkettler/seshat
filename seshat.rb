require 'redis'
require 'sinatra/base'
require_relative 'modules/redis_client'

Dir[File.join(__dir__, 'repositories', '*.rb')].each { |file| require file }

# https://en.wikipedia.org/wiki/Seshat
class Seshat < Sinatra::Base
  include RedisClient

  before do
    @client = RedisClient.init
    @repo = ActiveVisitorMetricRepository.new(@client)
  end

  post '/metrics/:key' do
    success = ->() { [200, JSON.generate({})] }
    error = ->(val) { halt 400, "Bad Value: #{val}" }

    val = params['value'].to_i

    # idempotent create
    @repo.create
    @repo.new_entity(val) ? success.call : error.call(val)
  end

  get '/metrics/:key/sum' do
    success = ->(sum) { [200, JSON.generate({value: sum})] }
    error = ->() { halt 400, "Bad request or no data to get. Try posting first" }

    sum = @repo.sum_vals
    sum ? success.call(sum) : error.call
  end

  # run Sinatra server
  at_exit { Seshat.run! } unless settings.test?
end
