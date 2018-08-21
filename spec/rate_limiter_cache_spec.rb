require_relative 'spec_helper'

describe 'RateLimiter::Cache' do

  describe 'creating a MemoryStore' do
    before do
      @cache = RateLimiter::Cache.new
    end

    it('should create a new store') do
      expect(@cache.store).is_a? ::ActiveSupport::Cache::MemoryStore
    end
  end

end
