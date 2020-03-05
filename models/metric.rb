require_relative '../helpers/api_helpers'
require_relative '../repositories/metric_repository'

class Metric
  include ApiHelpers

  ONE_HOUR = 3600000
  THIRTY_SECS = 30000

  KEY_WHITELIST = %w(ActiveVisitors SomeOtherMetric TestKey).freeze

  attr_accessor :interval

  def initialize(client, key, interval = ONE_HOUR)

    validated_key = validate_key(key)
    raise RuntimeError, 'Unknown Metric' unless validated_key || key.nil?

    @client = client
    @key = validated_key
    @repo = MetricRepository
    @interval = interval
  end

  def validate_key(string)
    key_class = to_class(string)
    key_class if KEY_WHITELIST.include?(key_class)
  end

  def create_index!
    @repo.create(@client, @key) unless index_exists? || @key.nil?
  end

  def new_entity(val)
    create_index! unless index_exists?
    @repo.new_entity(@client, @key, val) if valid_value?(val)
  end

  def sum_vals
    @repo.sum_vals_for_interval(@client, @key, @interval).last.last
  end

  def delete
    @repo.delete(@client, @key) if index_exists?
  end

  def get_info
    begin
      @repo.info(@client, @key)
    rescue Redis::CommandError
      raise "Can't get info; Index does not exist"
    end
  end

  def valid_value?(val)
    val.to_f && (val.to_f > 0)
  end

  def index_exists?
    begin
      get_info
    rescue
      nil
    end
  end

end
