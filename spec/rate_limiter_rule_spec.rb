require_relative 'spec_helper'

describe 'RateLimiter::Rule' do

  before do
    @period = 30
    RateLimiter.rule('requests/user2', :limit => 1, :period => @period) { |req| req }
  end

  describe 'creating a rule' do
    it('should have a rule') { RateLimiter.rules.key?('requests/user2') }
  end

  describe 'with one request' do
    before do
      RateLimiter.track('jack')
    end

    it 'should set the counter to 1' do
      key = "RateLimiter:#{Time.now.to_i / @period}:requests/user2:jack"
      expect(RateLimiter.cache.store.read(key)).to eq(1)
    end
  end

  describe 'with two requests' do
    before do
      2.times { RateLimiter.track('tom') }
    end

    it 'should set the counter to 2' do
      key = "RateLimiter:#{Time.now.to_i / @period}:requests/user2:tom"
      expect(RateLimiter.cache.store.read(key)).to eq(2)
    end
  end

end
