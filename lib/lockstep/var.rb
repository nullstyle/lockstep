module Lockstep
  ##
  # a Var is the main object within lockstep.  It implements the algorithm
  # described in the readme to provide a scaleable method of 
  # 
  class Var
    def initialize(storage, name, tick_size)
      @storage = storage
      @name = name
      @tick_size = tick_size

      refresh
    end
    
    ##
    # Write a value to this value that will become active at the next available 
    # tick, or optionally scheduled for the future
    # 
    # @param [Object] value the value to set
    # @param [Time] desired_active_time The earliest time you want this value to
    #   become available.  If this time is in the future it will become active
    #   at that time
    # @param [Fixnum] next_tick_size TODO
    def set(value, desired_active_time=Time.now, next_tick_size=@tick_size)
      
    end
    
    ##
    # Returns the value for this var that will be active (or was active) at the 
    # provided time.  Please note that lockstep periodically trims old tuples 
    # from it's storage system and so passing a Time object from the past will
    # result in undefined behaviour.
    # 
    # @param [Time] active_at The time to test against.  The value that was
    #   active, or will be active at this time will be returned
    # @return [Object] The value for this var
    def get(active_time=Time.now)
      refresh_if_needed
      active_at, value, tick_size = *active_tuple(active_time)
      value
    end

    def refresh_if_needed
      #TODO
      # check tick size of current value
      # if blah
      
      refresh
    end

    def purge_old_values
      
    end

    def refresh
      @tuples = storage.read(@name)
      #TODO: @next_check_at = current_time + active_tuple.tick_size
    end

    private
    def next_check_time
      
    end

    def storage
      @storage
    end

    def active_tuple(current_time)
      @tuples.reverse.find do |tuple|
        active_at, value, check_time = *tuple
        active_at < current_time
      end
    end

    def next_tuple(current_time)
      @tuples.find do |tuple|
        active_at, value, check_time = *tuple
        active_at > current_time
      end
    end

  end
end