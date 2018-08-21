module RateLimiter
  class Rule

    attr_reader :name, :limit, :period, :block

    def initialize(name, options, block)
      @name, @block = name, block
      @limit  = options[:limit]
      @period = options[:period]
    end

    def cache
      RateLimiter.cache
    end

    def against_by?(request)
      discriminator = block.call(request)
      return false unless discriminator

      key = "#{name}:#{discriminator}"
      count = cache.count(key, period)
      count > limit
    end

  end
end
