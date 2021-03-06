module RateLimiter
  class ExpirationInSeconds
    def initialize(seconds)
      @seconds = Integer(seconds)
    end

    def for(time)
      Result.new(time, expiration_in_seconds: @seconds)
    end

    class Result
      def initialize(time, expiration_in_seconds:)
        @time = Integer(time)
        @expiration = expiration_in_seconds
      end

      def valid?
        expires_in > 0
      end

      def expired?
        !valid?
      end

      def expires_in
        @expiration - (Time.now.to_i - @time)
      end
    end
  end
end
