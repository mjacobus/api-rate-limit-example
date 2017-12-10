require 'rails_helper'

RSpec.describe RateLimiter::ExpirationInSeconds do
  subject { described_class.new(10) }
  describe '#expiration_for.valid?' do
    it 'returns false when it has expired' do
      expect(
        subject.expiration_for(10.seconds.ago)
      ).not_to be_valid

      expect(
        subject.expiration_for(11.seconds.ago)
      ).not_to be_valid
    end

    it 'returns true when it has not expired' do
      expect(
        subject.expiration_for(Time.now)
      ).to be_valid

      expect(
        subject.expiration_for(Time.now.to_i)
      ).to be_valid

      expect(
        subject.expiration_for(9.seconds.ago)
      ).to be_valid
    end
  end

  describe '#expiration_for.expires_in' do
    it 'returns the number of seconds for expiration' do
      expect(
        subject.expiration_for(5.seconds.ago).expires_in
      ).to be(5)

      expect(
        subject.expiration_for(5.seconds.ago.to_i).expires_in
      ).to be(5)

      expect(
        subject.expiration_for(10.seconds.ago).expires_in
      ).to be(0)

      expect(
        subject.expiration_for(10.seconds.ago.to_i).expires_in
      ).to be(0)

      expect(
        subject.expiration_for(11.seconds.ago).expires_in
      ).to be(-1)

      expect(
        subject.expiration_for(11.seconds.ago.to_i).expires_in
      ).to be(-1)
    end
  end
end
