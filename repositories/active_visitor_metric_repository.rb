class ActiveVisitorMetricRepository

  ONE_HOUR = 3600000

  def initialize(client, interval = ONE_HOUR)
    @client = client
    @interval = interval
  end

  def create
    return if index_exists?
    @client.call('TS.CREATE', get_index)
  end

  def new_entity(value)
    return unless value && (value.to_f > 0)
    @client.call('TS.ADD', get_index, '*', value.to_f)
  end

  def sum_vals
    return unless index_exists?
    time = current_time_ms
    @client.call('TS.RANGE', get_index, time - @interval, time, 'AGGREGATION', 'SUM', @interval).first.last
  end


  private

  def current_time_ms
    @client.call('TIME')[0].to_i * 1000
  end

  def index_exists?
    begin
      @client.call('TS.INFO', get_index)
    rescue Redis::CommandError
      false
    end
  end

  def get_index
    'ActiveVisitors'
  end
end
