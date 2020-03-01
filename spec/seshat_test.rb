require_relative '../seshat'
require 'test/unit'
require 'rack/test'

class SeshatTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Seshat
  end

  def setup
    @client = Redis.new
  end

  def teardown
    @client.call('DEL', 'ActiveVisitors')
  end

  def test_post
    post '/metrics/active_visitors', value: 5
    assert_equal '{}', last_response.body
  end
end
