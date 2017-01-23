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

# optional
Waiting.default_max_attempts = max_attempts # defaults to 60
Waiting.default_interval = interval # seconds, defaults to 5

# will poll every interval max_attempts times until something returns true
Waiting.wait do |waiter|
  waiter.done if something
end

# Specify the max_attempts and interval for each instance of the Waiting
Waiting.wait(interval: interval, max_attempts: max_attempts) do |waiter|
  waiter.done if something
end

# Waiting can do exponential backoff
Waiting.default_exp_base = exp_base # defaults to 1, for a constant wait interval
Waiting.default_max_interval = max_interval # defaults to unbounded

# Will wait for: 2,4,8,8...
Waiting.wait(interval: 2, exp_base: 2, max_interval: 8) do |waiter|
  waiter.done if something
end

# To get the parameters of the wait
Waiting.wait do |waiter|
  puts waiter.attempts
  puts waiter.exp_base
  puts waiter.interval
  puts waiter.max_attempts
  puts waiter.max_interval
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/meringu/waiting.
