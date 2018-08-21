module RateLimiter
  class Cache

    attr_accessor :prefix
    attr_reader :store

    def initialize
      # Only tested with FileStore and MemoryStore
      @store = defined?(::Rails.cache) ? ::Rails.cache : ::ActiveSupport::Cache::MemoryStore.new
      @prefix = 'RateLimiter'
    end

    def count(key, period)
      full_key, expires_in = key_and_expiry(key, period)
      do_count(full_key, expires_in)
    end

    private

    def key_and_expiry(key, period)
      last_time = Time.now.to_i

      expires_in = (period - (last_time % period) + 1).to_i
      ["#{prefix}:#{(last_time / period).to_i}:#{key}", expires_in]
    end

    def do_count(full_key, expires_in)
      result = store.increment(full_key, 1, :expires_in => expires_in)
      store.write(full_key, 1, :expires_in => expires_in) if result.nil?
      result || 1
    end

  end
end
