require 'spec_helper'

RSpec.describe RateLimiter::Strategy::IpBasedStrategy do
  before do
    storage.keys.map { |key| storage.remove(key) }
  end

  let(:config) { ENV.to_h.merge(app_env: Rails.env) }
  let(:factory) { RateLimitterMiddlewareFactory.new(config: config) }

  let(:storage) { factory.storage }
  let(:app) { proc { |_env| app_response } }

  let(:strategy) do
    described_class.new(
      storage: storage,
      max_number_of_requests: 5,
      time_range_in_seconds: 10
    )
  end

  let(:env) { Hash['REMOTE_ADDR' => 'the-ip'] }
  let(:env2) { Hash['REMOTE_ADDR' => 'the-ip2'] }
  let(:app_response) { [200, { foo: :bar }, ['ok']] }

  describe '#handle_request' do
    it 'responds ok while limit is not reached' do
      # allowed 5 times
      1.upto(5) do
        response = strategy.handle_request(next_middleware: app, env: env)
        expect(response).to eq(app_response)
      end

      Timecop.travel(3.seconds.from_now) do
        # denied
        response = strategy.handle_request(next_middleware: app, env: env)
        expect(response).to eq([429, {}, ['Rate limit exceeded. Try again in 7 seconds']])

        # different ip OK
        response = strategy.handle_request(next_middleware: app, env: env2)
        expect(response).to eq(app_response)
      end

      Timecop.travel(4.seconds.from_now) do
        # denied
        response = strategy.handle_request(next_middleware: app, env: env)
        expect(response).to eq([429, {}, ['Rate limit exceeded. Try again in 6 seconds']])
      end

      Timecop.travel(14.seconds.from_now) do
        # allowed 5 times
        1.upto(5) do
          response = strategy.handle_request(next_middleware: app, env: env)
          expect(response).to eq(app_response)
        end

        # denied
        response = strategy.handle_request(next_middleware: app, env: env)
        expect(response).to eq([429, {}, ['Rate limit exceeded. Try again in 10 seconds']])
      end
    end
  end
end
