require_relative '../models/metric'
require_relative '../modules/redis_client'
require "test/unit"
require 'redis'


class MetricTest < Test::Unit::TestCase
  include RedisClient

  TEST_KEY = 'test_key'

  def setup
    @client = RedisClient.init
    @metric = Metric.new(@client, TEST_KEY)
  end

  def teardown
    @metric.delete
  end

  def test_create_index!
    @metric.create_index!
    assert_not_nil(@metric.index_exists?)
  end

  def test_new_entity
    @metric.new_entity(5)
    assert_equal(1, @metric.get_info[1])
  end

  def test_new_entity_bad_key
    assert_raise RuntimeError, 'Unknown Key' do
      Metric.new(@client, 'bogo_sort')
    end
  end

  def test_new_entity_bad_value
    @metric.new_entity(-2)

    assert_equal(0, @metric.get_info[1])
  end

  def test_sum_vals
    @metric.new_entity(5)
    # sleep 1 # wait for writes to finish
    @metric.new_entity(15)
    sleep 1
    assert_equal(2, @metric.get_info[1])
    assert_equal("20", @metric.sum_vals)
  end

  def test_sum_vals_expire
    @metric.interval = 2000
    @metric.new_entity(15)

    sleep 1 # wait for writes to finish

    assert_equal("15", @metric.sum_vals)
    sleep 3 # wait for interval to expire
    assert_equal("0", @metric.sum_vals)
  end

end
