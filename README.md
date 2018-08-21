# RateLimiter

A rate-limiting gem that stops a particular requestor from making too many requests within a particular period of time.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rate_limiter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rate_limiter

## Usage

Example 1: Allowing 100 requests per hour, and limit by ip address

```ruby
# Setup limiting rules
RateLimiter.rule('requests/ip', limit: 100, period: 1.hour.to_i) { |req| req.remote_ip }
# Track the requests. It will return error message if over the limit, otherwise nil.
RateLimiter.track(request)
```

Alternately, you can directly passing the user name as the parameter

```ruby
# Setup limiting rules
RateLimiter.rule('requests/username', limit: 100, period: 1.hour.to_i) { |username| username }
# Track by user names. It will return error message if over the limit, otherwise nil.
RateLimiter.track(username)
```

## Rule Options

###name
specific rule name, must be unique
  
###options

:limit -- the request limit during a fixed time. 

:period -- the limit duration
  
###block
the block to calculate the discriminator of requests

## Response

Normally, we get some rate-limiting response as below:

"Rate Limit Exceeded. Try again in 30 seconds."

However, we can also customise the response.

```ruby
RateLimiter.response = lambda { |rule|
  "Rate Limit Exceeded. Try again in half minute."
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rate_limiter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

