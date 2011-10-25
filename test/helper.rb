require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'shoulda'
require 'redis'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'redis_throttle'

config_file = File.join(File.dirname(__FILE__), "redis.yml")
unless File.exists?(config_file)
  $stderr.puts "redis.yml not found in test/ -- rename redis.yml.dist to redis.yml and edit the config info in order to run tests"
  exit
end

redis_config = YAML.load_file(config_file)["development"]
REDIS = Redis.new(redis_config.merge({:thread_safe => true}))

unless REDIS.dbsize == 0
  $stderr.puts "CAUTION: this wipes whatever redis db you give it when it runs tests. Give it a shiny new empty db"
end

RedisThrottle.redis = REDIS

class Test::Unit::TestCase
end
