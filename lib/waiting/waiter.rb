require 'waiting/timed_out_error'

class Waiting
  # The class that patiently waits
  #
  class Waiter
    # The current attempt number
    #
    # @return [Integer]
    #
    attr_reader :attempts

    # The exp base
    #
    # @return [Numeric]
    #
    attr_accessor :exp_base

    # The interval
    #
    # @return [Numeric]
    #
    attr_accessor :interval

    # The max attempts
    #
    # @return [Numeric]
    #
    attr_accessor :max_attempts

    # The max interval
    #
    # @return [Numeric]
    #
    attr_accessor :max_interval

    # @param interval [Numeric] Polling interval in seconds.
    # @param max_attempts [Numeric] Number of attempts before timing out.
    # @param exp_base [Numeric] Increases the interval by the power of attempts.
    # @param max_interval [Numeric] Interval limit for exponential backoff.
    #
    # @yield Block to check if the wait is over.
    # @yieldparam waiter [Waiting::Waiter] call +#done+ if the wait is over
    #
    def initialize(exp_base: Waiting.default_exp_base,
                   interval: Waiting.interval,
                   max_attempts: Waiting.max_attempts,
                   max_interval: Waiting.max_interval)

      @exp_base = exp_base
      @interval = interval
      @max_attempts = max_attempts
      @max_interval = max_interval

      @done = false
      @attempts = 0
    end

    # Mark the waiter as done
    #
    def done
      @done = true
    end

    # Is the waiter done?
    #
    # @return [Boolean] if the waiter is done
    #
    def done?
      @done
    end

    # Waits for +#done+ to be called
    #
    # @raise [Waiting::TimedOutError] if +#done+ is not called in time
    #
    def wait
      loop do
        if @attempts >= max_attempts
          raise Waiting::TimedOutError,
                "Timed out after #{interval * max_attempts}s"
        end

        yield(self)
        break if done?
        wait_once
      end
    end

    private

    def wait_once
      sleep [exp_base**attempts * interval, max_interval].compact.min
      @attempts += 1
    end
  end
end
