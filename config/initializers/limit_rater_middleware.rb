policy = RateLimiter::Policy::RouteBasedPolicy.new(
  routes: [
    '/',
    '/test-route',
  ]
)

redis = Redis.new(url: ENV.fetch('REDIS_URL'))
redis_namespace = Redis::Namespace.new(ns: "rate_limiter_#{Rails.env}", redis: redis)

storage = RateLimiter::Storage::RedisStorage.new(
  expiration: RateLimiter::ExpirationInSeconds.new(ENV['RATE_LIMIT_POLICY_TIME_IN_SECONDS']),
  redis: redis_namespace
)

strategy = RateLimiter::Strategy::IpBasedStrategy.new(
  storage:  storage,
  max_number_of_requests: ENV['RATE_LIMIT_POLICY_NUMBER_OF_REQUESTS'],
  time_range_in_seconds: ENV['RATE_LIMIT_POLICY_TIME_IN_SECONDS']
)

Rails.application.configure do
  config.middleware.use RateLimiter::Middleware, strategy: strategy, policy: policy

  # used in test environment
  config.rate_limiter = {
    storage: storage,
    time_range_in_seconds: Integer(ENV['RATE_LIMIT_POLICY_TIME_IN_SECONDS'])
  }
end
