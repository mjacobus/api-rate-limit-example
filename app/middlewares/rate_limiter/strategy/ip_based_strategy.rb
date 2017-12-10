module RateLimiter
  module Strategy
    class IpBasedStrategy
      STATUS_DENIED = 429

      def initialize(storage:, max_number_of_requests:, time_range_in_seconds:)
        @storage = storage
        @max_requests = Integer(max_number_of_requests)
        @time_range = Integer(time_range_in_seconds)
      end

      def handle_request(next_middleware:, env:)
        key = key_from_env(env)
        data = fetch_and_increment(key)

        if data[:count] <= @max_requests
          return next_middleware.call(env)
        end

        [STATUS_DENIED, {}, [message(data)]]
      end

      private

      def fetch_and_increment(key)
        data = @storage.fetch(key, timestamp: true) { Hash[count: 0] }
        data[:count] += 1
        @storage.store(key, data)
        data
      end

      def key_from_env(env)
        env['REMOTE_ADDR']
      end

      def message(data)
        seconds = ExpirationInSeconds.new(@time_range).for(data[:_timestamp]).expires_in
        "Rate limit exceeded. Try again in #{seconds} seconds"
      end
    end
  end
end
