module RateLimiter
  module Storage
    class RedisStorage
      def initialize(redis:, expiration:)
        @redis = redis
        @expiration = expiration
      end

      def fetch(key, options = {}, &block)
        value = @redis.get(key)

        unless value.nil?
          value = validated(value, options)
        end

        unless value.nil?
          return value
        end

        if block
          yield
        end
      end

      def store(key, value)
        value = JSON.dump(value.merge(_timestamp: Time.now.to_i))
        @redis.set(key, value)
      end

      def remove(key)
        @redis.del(key)
      end

      def keys
        @redis.keys
      end

      private

      def validated(string_value, options = {})
        value = JSON.parse(string_value).symbolize_keys

        if @expiration.for(value[:_timestamp]).expired?
          return
        end

        unless options.fetch(:timestamp) { false }
          value.delete(:_timestamp)
        end
        value
      end
    end
  end
end
