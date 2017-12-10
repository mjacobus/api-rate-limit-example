class RateLimitterMiddlewareFactory
  attr_reader :config

  def initialize(config:)
    @config = config
  end

  def new(app)
    RateLimiter::Middleware.new(app, strategy: strategy, policy: policy)
  end

  def policy
    @policy ||= RateLimiter::Policy::RouteBasedPolicy.new(routes: protected_routes)
  end

  def protected_routes
    ['/', '/test-route']
  end

  def redis
    @redis ||= Redis::Namespace.new(
      ns: namespace,
      redis: Redis.new(url: config.fetch('REDIS_URL'))
    )
  end

  def namespace
    "rate_limiter_#{app_env}"
  end

  def storage
    @storage ||= RateLimiter::Storage::RedisStorage.new(
      expiration: RateLimiter::ExpirationInSeconds.new(time_range),
      redis: redis
    )
  end

  def strategy
    @strategy ||= RateLimiter::Strategy::IpBasedStrategy.new(
      storage:  storage,
      max_number_of_requests: max_requests,
      time_range_in_seconds: time_range
    )
  end

  def app_env
    config.fetch(:app_env)
  end

  def max_requests
    Integer(config.fetch('RATE_LIMIT_POLICY_NUMBER_OF_REQUESTS'))
  end

  def time_range
    Integer(config.fetch('RATE_LIMIT_POLICY_TIME_IN_SECONDS'))
  end
end
