require "spec_helper"

describe RateLimiter do

  before do
    RateLimiter.rule('requests/user1', limit: 1, period: 30) { |req| req }
  end

  describe 'with one request' do
    it 'should return nil' do
      expect(RateLimiter.track('mark')).to be_nil
    end
  end

  describe 'with two requests' do
    it 'should return error message' do
      expect(RateLimiter.track('chris')).to be_nil
      expect(RateLimiter.track('chris')).to eq("Rate Limit Exceeded. Try again in 30 seconds.")
    end

    it 'should return customised error message' do
      RateLimiter.response = lambda { |rule|
        "Rate Limit Exceeded. Try again in half minute."
      }
      expect(RateLimiter.track('chris')).to eq("Rate Limit Exceeded. Try again in half minute.")
    end
  end

end
