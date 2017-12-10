require 'rails_helper'

RSpec.describe RateLimiter::Policy::RouteBasedPolicy do
  let(:policy) do
    described_class.new(routes: ['/foo/baz'])
  end

  let(:env) do
    { 'REQUEST_PATH' => '/foo/baz' }
  end

  describe '#applicable' do
    it 'returns true when route matches' do
      expect(policy.applicable?(env)).to be true
    end

    it 'returns false when route does not matches' do
      env['REQUEST_PATH'] = '/some-other-route'

      expect(policy.applicable?(env)).to be false
    end
  end
end
