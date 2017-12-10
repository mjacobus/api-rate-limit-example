require 'rails_helper'

RSpec.describe RateLimiter::ExpirationInSeconds do
  let(:expiration) { described_class.new(10) }

  describe '#for.valid?' do
    it 'returns false when it has expired' do
      expect(
        expiration.for(10.seconds.ago)
      ).to be_expired

      expect(
        expiration.for(11.seconds.ago)
      ).to be_expired
    end

    it 'returns true when it has not expired' do
      expect(
        expiration.for(Time.now)
      ).to be_valid

      expect(
        expiration.for(Time.now.to_i)
      ).to be_valid

      expect(
        expiration.for(9.seconds.ago)
      ).to be_valid
    end
  end

  describe '#for.expires_in' do
    it 'returns the number of seconds for expiration' do
      expect(
        expiration.for(5.seconds.ago).expires_in
      ).to be(5)

      expect(
        expiration.for(5.seconds.ago.to_i).expires_in
      ).to be(5)

      expect(
        expiration.for(10.seconds.ago).expires_in
      ).to be(0)

      expect(
        expiration.for(10.seconds.ago.to_i).expires_in
      ).to be(0)

      expect(
        expiration.for(11.seconds.ago).expires_in
      ).to be(-1)

      expect(
        expiration.for(11.seconds.ago.to_i).expires_in
      ).to be(-1)
    end
  end
end
