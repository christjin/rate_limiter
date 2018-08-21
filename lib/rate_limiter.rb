require "rate_limiter/version"

module RateLimiter

  autoload :Rule, 'rate_limiter/rule'
  autoload :Cache, 'rate_limiter/cache'

  @@response = lambda {|rule|
    "Rate Limit Exceeded. Try again in #{rule.period} seconds."
  }

  module_function

  def cache
    @cache ||= RateLimiter::Cache.new
  end

  # Public: Setup rate limiting rules
  #
  # name - specific rule name, must be unique
  # options - rule options include :limit and :period. :limit is the request limit during a
  # fixed time. :period is the limit duration
  # block - the block to calculate the discriminator of requests
  #
  # Examples
  #
  #   RateLimiter.rule('requests/ip', limit: 1, period: 30) { |req| req.remote_ip }
  #
  # Returns a Rule object
  def rule(name, options, &block)
    rules[name] = RateLimiter::Rule.new(name, options, block)
  end

  def rules
    @rules ||= {}
  end

  def limited?(request)
    rules.each_pair do |name, rule|
      return rule if rule.against_by?(request)
    end
    nil
  end

  # Public: Customising limiting response
  #
  # response - a message string or a lambda to dynamically generate the message
  #
  # Examples
  #
  #   RateLimiter.response = lambda { |rule|
  #     "Rate Limit Exceeded. Try again in half minute."
  #   }
  def response=(response)
    @@response = response
  end

  # Public: Tracking requests. If it is over the limit, return error message, otherwise nil
  #
  # request - It can be any objects. Normally, it is the request object, or user name string
  # of any calculated request string.
  #
  # Examples
  #
  #   RateLimiter.track(request)
  #
  # Returns a customised response, or nil if it is not over the limit
  def track(request)
    rule = self.limited?(request)
    if rule
      @@response.call(rule)
    else
      nil
    end
  end

end
