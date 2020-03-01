require_relative '../repositories/metric_repository'
require_relative '../modules/redis_client'
require "test/unit"
require 'redis'

class TestMetricRepository < MetricRepository
  def get_info
    begin
      @client.call('TS.INFO', get_index)
    rescue Redis::CommandError
      nil
    end
  end

  def get_index
    'TestMetric'
  end
end


class MetricRepositoryTest < Test::Unit::TestCase
  include RedisClient

  def setup
    @client = RedisClient.init
    @repo = TestMetricRepository.new(@client)
  end

  def teardown
    @client.call('DEL', @repo.get_index)
  end

  def test_create
    assert_nil(@repo.get_info)
    @repo.create
    assert_not_nil(@repo.get_info)
  end

  def test_new_entity
    @repo.new_entity(5)
    assert_equal(1, @repo.get_info[1])
  end

  def test_sum_vals
    repo = TestMetricRepository.new(@client)
    repo.new_entity(5)
    sleep 1
    repo.new_entity(15)
    sleep 1 # wait for writes to finish
    assert_equal(2, repo.get_info[1])
    assert_equal("20", repo.sum_vals)
  end

  def test_sum_vals_expire
    repo = TestMetricRepository.new(@client, 2000) # 2 second window
    repo.new_entity(15)

    sleep 1 # wait for writes to finish

    assert_equal("15", repo.sum_vals)
    sleep 3 # wait for interval to expire
    assert_equal("0", repo.sum_vals)
  end

end
