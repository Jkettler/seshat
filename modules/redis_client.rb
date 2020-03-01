require 'redis'

module RedisClient
  @client = nil

  def self.init
    @client ||= Redis.new
  end
end
