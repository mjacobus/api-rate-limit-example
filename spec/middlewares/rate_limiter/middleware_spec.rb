require 'spec_helper'

RSpec.describe RateLimiter::Middleware do
  let(:env) { {  env: :value } }
  let(:strategy) { instance_double(RateLimiter::Strategy::IpBasedStrategy) }
  let(:policy) { instance_double(RateLimiter::Policy::RouteBasedPolicy) }

  let(:app) do
    proc do |env|
      [200, ['ok'], { foo: :bar }.merge(env)]
    end
  end

  subject { described_class.new(app, strategy: strategy, policy: policy) }

  describe '#call' do
    context 'when policy is not applicable' do
      before do
        allow(policy).to receive(:applicable?).with(env) { false }
      end

      it 'delegates call to app when policy is not applicable' do
        expected_response = [200, ['ok'], { foo: :bar, env: :value }]

        response = subject.call(env)

        expect(response).to eq(expected_response)
      end
    end

    context 'when policy applies' do
      before do
        allow(policy).to receive(:applicable?).with(env) { true }

        allow(strategy).to receive(:handle_request).with(next_middleware: app, env: env) do
          'formatted_response'
        end
      end

      it 'returns the formatted response' do
        response = subject.call(env)

        expect(response).to eq('formatted_response')
      end
    end
  end
end
