require 'waiting/waiter'

# Waits for things so you don't have to
#
class Waiting
  # @param interval [Numeric] Polling interval in seconds.
  # @param max_attempts [Numeric] Number of attempts before timing out.
  # @param exp_base [Numeric] Increases the interval by the power of attempts.
  # @param max_interval [Numeric] Interval limit for exponential backoff.
  #
  # @yield Block to check if the wait is over.
  # @yieldparam waiter [Waiting::Waiter] call +#done+ if the wait is over
  #
  def initialize(exp_base: self.class.default_exp_base,
                 interval: self.class.default_interval,
                 max_attempts: self.class.default_max_attempts,
                 max_interval: self.class.default_max_interval,
                 &block)

    @exp_base = exp_base
    @interval = interval
    @max_attempts = max_attempts
    @max_interval = max_interval

    @block = block
  end

  class << self
    # The default exp base
    #
    # @return [Numeric]
    #
    attr_accessor :default_exp_base

    # The default interval
    #
    # @return [Numeric]
    #
    attr_accessor :default_interval

    # The default max attempts
    #
    # @return [Numeric]
    #
    attr_accessor :default_max_attempts

    # The default max interval
    #
    # @return [Numeric]
    #
    attr_accessor :default_max_interval
  end

  self.default_exp_base = 1
  self.default_interval = 5
  self.default_max_attempts = 60
  self.default_max_interval = nil

  # @param interval [Numeric] Polling interval in seconds.
  # @param max_attempts [Numeric] Number of attempts before timing out.
  # @param exp_base [Numeric] Increases the interval by the power of attempts.
  # @param max_interval [Numeric] Interval limit for exponential backoff.
  #
  # @yield Block to check if the wait is over.
  # @yieldparam waiter [Waiting::Waiter] call +#done+ if the wait is over
  #
  def wait(exp_base: @exp_base,
           interval: @interval,
           max_attempts: @max_attempts,
           max_interval: @max_interval,
           &block)

    Waiter.new(
      exp_base: exp_base,
      interval: interval,
      max_attempts: max_attempts,
      max_interval: max_interval
    ).wait(&(block || @block))
  end

  # @see +#wait+
  #
  # @param interval [Numeric] Polling interval in seconds.
  # @param max_attempts [Numeric] Number of attempts before timing out.
  # @param exp_base [Numeric] Increases the interval by the power of attempts.
  # @param max_interval [Numeric] Interval limit for exponential backoff.
  #
  # @yield Block to check if the wait is over.
  # @yieldparam waiter [Waiting::Waiter] call +#done+ if the wait is over
  #
  def self.wait(exp_base: default_exp_base,
                interval: default_interval,
                max_attempts: default_max_attempts,
                max_interval: default_max_interval,
                &block)

    new(exp_base: exp_base,
        interval: interval,
        max_attempts: max_attempts,
        max_interval: max_interval,
        &block).wait
  end
end
