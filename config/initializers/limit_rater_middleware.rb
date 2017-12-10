Rails.application.configure do
  config.middleware.use RateLimitterMiddlewareFactory.new(
    config: ENV.to_h.merge(app_env: Rails.env)
  )
end
