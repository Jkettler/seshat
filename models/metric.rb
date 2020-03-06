require_relative '../repositories/metric_repository'

class Metric

  ONE_HOUR = 3600000
  THIRTY_SECS = 30000

  KEY_WHITELIST = %w(active_visitors some_other_metric test_key).freeze

  attr_accessor :interval

  def initialize(client, key, interval = ONE_HOUR)

    validate_client client
    validate_key key
    validate_interval interval

    @repo = MetricRepository
    @client = client
    @key = key
    @interval = interval
    @created_at = @repo.current_time_ms(@client)

    create_index! unless index_exists?
  end

  def new_entity(val)
    validate_value val
    @repo.new_entity(@client, @key, val)
  end

  def sum_vals
    @repo.sum_vals_for_interval(@client, @key, @interval).last.last
  end

  def delete_key
    @repo.delete(@client, @key) if index_exists?
  end

  def get_info
    begin
      @repo.info(@client, @key)
    rescue Redis::CommandError
      raise "Can't get info; Index does not exist"
    end
  end

  def index_exists?
    begin
      get_info
    rescue
      nil
    end
  end

  def validate_interval(interval)
    raise RangeError, 'Interval must be a positive integer' unless interval && interval.to_i > 0
  end

  def validate_client(client)
    raise ArgumentError, 'Invalid redis client provided' unless client.is_a? Redis
  end

  def validate_value(val)
    raise ArgumentError, "Invalid Value: #{val}" unless val && (val.to_f > 0)
  end

  def validate_key(string)
    raise ArgumentError, "Unknown Metric: #{string}" unless KEY_WHITELIST.include?(string)
  end

  def create_index!
    @repo.create(@client, @key) unless index_exists?
  end

end
