require_relative '../repositories/active_visitor_metric_repository'
require "test/unit"
require 'redis'

class MetricRepositoryTest < ActiveVisitorMetricRepository
  def get_info
    begin
      @client.call('TS.INFO', get_index)
    rescue Redis::CommandError
      nil
    end
  end

  def get_index
    'MetricTest'
  end
end


class ActiveVisitorMetricRepoTest < Test::Unit::TestCase

  def setup
    @client = Redis.new
    @repo = MetricRepositoryTest.new(@client)
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
    repo = MetricRepositoryTest.new(@client, 1000)
    repo.new_entity(5)
    repo.new_entity(5)
    assert_equal(2, repo.get_info[1])
    assert_equal("10", repo.sum_vals)
    sleep 2
    assert_equal("0", repo.sum_vals)
  end

end
