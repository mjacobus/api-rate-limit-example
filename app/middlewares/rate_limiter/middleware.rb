module RateLimiter
  class Middleware
    def initialize(app, strategy:, policy:)
      @app = app
      @strategy = strategy
      @policy = policy
    end

    def call(env)
      if @policy.applicable?(env)
        return @strategy.handle_request(next_middleware: @app, env: env)
      end

      @app.call(env)
    end
  end
end
