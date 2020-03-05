class MetricRepository

  COMMANDS = {
      add: 'TS.ADD',
      create: 'TS.CREATE',
      range: 'TS.RANGE',
      info: 'TS.INFO',
      time: 'TIME',
      delete: 'DEL'
  }.freeze


  class << self
    def create(client, key)
      client.call(COMMANDS[:create], key)
    end

    def new_entity(client, key, value)
      client.call(COMMANDS[:add], key, '*', value)
    end

    def sum_vals_for_interval(client, key, interval)
      start_time = current_time_ms(client)
      client.call(COMMANDS[:range], key, start_time - interval, start_time, 'AGGREGATION', 'SUM', interval)
    end

    def current_time_ms(client)
      client.call(COMMANDS[:time]).first.to_i * 1000
    end

    def delete(client, key)
      client.call(COMMANDS[:delete], key)
    end

    def info(client, key)
      client.call(COMMANDS[:info], key)
    end
  end
end
