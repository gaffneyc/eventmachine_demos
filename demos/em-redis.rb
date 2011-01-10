require 'bundler/setup'
Bundler.require

EventMachine.run do
  redis = EM::Protocols::Redis.connect

  redis.set("test", "5000") do |_|
    redis.get("test") do |result|
      # "5000"
      puts result.inspect

      redis.delete("test")
    end
  end
end