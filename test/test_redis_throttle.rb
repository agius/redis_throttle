require 'helper'

class TestRedisThrottle < Test::Unit::TestCase
  
  def setup
    REDIS.flushdb
  end
  
  def teardown
    REDIS.flushdb
  end
  
  should "Rate limit a block based on a key" do
    number = 0
    RedisThrottle.limit(30) do
      number += 1
    end
    assert_equal(1, number)
  end
  
  should "Namespace rate limiting with args" do
    number = 0
    0.upto(5) do |n|
      10.times do
        RedisThrottle.limit(30, n) do
          number += 1
        end
      end
    end
    assert_equal(6, number)
  end
end
