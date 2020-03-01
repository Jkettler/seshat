require 'redis'
require 'sinatra/base'

Dir[File.join(__dir__, 'repositories', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'models', '*.rb')].each { |file| require file }

# https://en.wikipedia.org/wiki/Seshat
class Seshat < Sinatra::Base

  before do
    @client ||= Redis.new
    @repo ||= ActiveVisitorMetricRepository.new(@client)
  end

  post '/metrics/:key' do
    success = ->() { [200, JSON.generate({})] }
    error = ->(val) { halt 400, "unrecognized val: #{val}" }

    val = params['value'].to_i

    # idempotent create TimeSeries key/value store
    @repo.create
    @repo.new_entity(val) ? success.call : error.call(val)
  end

  get '/metrics/:key/sum' do
    success = ->(sum) { [200, JSON.generate({value: sum})] }
    error = ->() { halt 400 }

    sum = @repo.sum_vals
    sum ? success.call(sum) : error.call
  end

  # run Sinatra server
  at_exit { Seshat.run! } unless settings.test?
end
