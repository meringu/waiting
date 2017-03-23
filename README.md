[![Build Status](https://travis-ci.org/meringu/waiting.svg?branch=master)](https://travis-ci.org/meringu/waiting)

# Waiting

Waits so you don't have to!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'waiting'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install waiting

## Usage

```ruby
require 'waiting'


# Optionally set defaults.
#
Waiting.exp_base = exp_base         # defaults to 1
Waiting.interval = interval         # defaults to 5
Waiting.max_attempts = max_attempts # defaults to 60
Waiting.max_interval = max_interval # defaults to nil


# Will poll every interval, max_attempts times until something is true
#
Waiting.wait do |waiter|
  waiter.done if something
end


# Override the defaults here
#
Waiting.wait(exp_base: exp_base,
             interval: interval,
             max_attempts: max_attempts,
             max_interval: max_interval
            ) do |waiter|
  waiter.done if something
end


# Or make an instance of Waiting to pass around
#
waiting = Waiting.new(exp_base: exp_base,
                      interval: interval,
                      max_attempts: max_attempts,
                      max_interval: max_interval
                     ) do |waiter|
  waiter.done if something
end


# And get it to wait
#
waiting.wait


# Or overide any parameters here again
#
waiting.wait(exp_base: exp_base,
             interval: interval,
             max_attempts: max_attempts,
             max_interval: max_interval
            ) do |waiter|
  waiter.done if something
end


# Access the wait parameters during the wait
#
waiting.wait do |waiter|
  puts "attempts: #{waiter.attempts}"
  puts "exp_base: #{waiter.exp_base}"
  puts "interval: #{waiter.interval}"
  puts "max_attempts: #{waiter.max_attempts}"
  puts "max_interval: #{waiter.max_interval}"
  waiter.done if something
end
# =>
#   attempts: 0
#   exp_base: 1
#   interval: 5
#   max_attempts: 60
#   max_interval: nil


# Leverage exp base for exponential back off
#
# Will wait for: 1, 2, 4, 8, 16, 16, 16...
#
waiting.wait(exp_base: 2,
             interval: 1,
             max_attempts: 16
            ) do |waiter|
  waiter.done if something
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/meringu/waiting.
