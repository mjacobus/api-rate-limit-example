module RateLimiter
  module Storage
    class RedisStorage
      def initialize(redis:)
        @redis = redis
      end

      def fetch(key, &block)
        value = @redis.get(key)
        return parsed(value) unless value.nil?

        yield if block
      end

      def store(key, value)
        value = JSON.dump(value)
        @redis.set(key, value)
      end

      def remove(key)
        @redis.del(key)
      end

      def keys
        @redis.keys
      end

      private

      def parsed(string_value)
        JSON.parse(string_value).symbolize_keys
      end
    end
  end
end
