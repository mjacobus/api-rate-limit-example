require 'rails_helper'

RSpec.describe RateLimiter::Storage::RedisStorage do
  let(:global_redis) { Redis.new(url: ENV.fetch('REDIS_URL')) }
  let(:redis) { Redis::Namespace.new(ns: 'test_api_rate', redis: global_redis) }
  let(:expiration) { RateLimiter::ExpirationInSeconds.new(10) }
  let(:storage) { described_class.new(redis: redis, expiration: expiration) }

  before do
    storage.keys.each do |key|
      storage.remove(key)
    end
  end

  describe '#fetch' do
    it 'returns nil when nothing exists' do
      expect(storage.fetch('key')).to be_nil
    end

    it 'returns value in block when value is nil' do
      expect(storage.fetch('unexisting') { 'bar' }).to eq('bar')
    end

    it 'returns result when there is one' do
      value = { foo: 'bar' }

      storage.store('key', value)

      expect(storage.fetch('key')).to eq(value)
    end
  end

  describe '#store' do
    it 'can overrite value' do
      value = { foo: 'bar' }
      storage.store('key', value)

      value = { foo: 'new_value' }
      storage.store('key', value)

      expect(storage.fetch('key')).to eq(value)
    end
  end

  describe '#remove' do
    it 'removes a key' do
      redis.set('foo', '{}')

      storage.remove('foo')

      expect(storage.fetch('foo')).to be_nil
    end
  end

  describe '#keys' do
    it 'returns the redis keys' do
      redis.set('foo', 'value')
      redis.set('bar', 'value')

      expect(storage.keys).to eq(%w[bar foo])
    end
  end
end
