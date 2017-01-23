module Waiting
  class Waiter
    attr_accessor :attempts
    attr_accessor :exp_base
    attr_accessor :interval
    attr_accessor :max_attempts
    attr_accessor :max_interval

    # Waiter is in waiting state to start with
    def initialize
      @done = false
    end

    # Mark the waiter as done
    def done
      @done = true
    end

    # Is the waiter done?
    # @return [Boolean] if the waiter is done
    def done?
      @done
    end
  end
end
