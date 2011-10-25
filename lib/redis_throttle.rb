class RedisThrottle
  
  class << self
    attr_accessor :redis
    
    def limit(time_in_secs, *args, &block)
      key = ["redis-throttle", block_id(&block), *args].join('-')
      return if @redis.get(key)
      yield
      @redis.setex(key, time_in_secs, Time.now)
    end
    
    # uses filename / line no. as identifier for block. cheap, but should generally work
    def block_id &block
      block.inspect =~ /(\w+\.rb:\d+)/
      $1
    end
  end
end