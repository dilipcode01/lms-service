require 'redis'
require 'json'

class RedisEventPublisher
  STREAM = 'lms_events'

  def self.publish(event_type, event)
    redis = Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379/0')
    data = {
      event_type: event_type,
      data: event.as_json
    }.to_json
    redis.xadd(STREAM, { data: data })
  end
end 