class HomeController < ApplicationController
  def index
    redis = Redis.new(url: ENV.fetch('REDIS_URL'))
    store = Redis::Namespace.new(ns: 'api_rate', redis: redis)
    next_count = Integer(store.get('count') || 0) + 1
    store.set('count', next_count)

    render plain: 'ok' + store.get('count')
  end
end
