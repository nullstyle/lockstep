module Lockstep
  ##
  # a Var is the main object within lockstep.  It implements the algorithm
  # described in the readme to provide a scaleable method of 
  # 
  class Var
    attr_reader :tuples
    attr_reader :last_checked_at
    
    def initialize(storage, name, default_tick_size)
      @storage = storage
      @name = name
      @default_tick_size = default_tick_size

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
    # @return [Time, false] The time at which the new value will become active, 
    #   or false if the write failed
    def set(value, desired_active_time=Time.now, next_tick_size=@default_tick_size)
      active_time = next_available_change_at(desired_active_time)
      
      @storage.write(@name, active_time, value, next_tick_size)
      
      active_time
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

    ##
    # Refreshes the set of cached tuples only if enough time has elapsed since
    # the last check
    # 
    # @param [Time] current_time The time to test against to 
    #   see whether we should check again
    # @return [Array,nil] An array of loaded tuples if storage 
    #   was checked, nil otherwise
    def refresh_if_needed(current_time=Time.now)
      refresh(current_time) if current_time > next_check_at(@last_checked_at)
    end

    ##
    # Removes expired tuples from storage.
    # 
    # @param [Fixnum] old_values_to_keep How many expired tuples to keep around
    def purge_old_values(old_values_to_keep=5)
      #TODO
    end

    ##
    # Refreshes the set of cached tuples from storage, regardless of whether it
    #  is time to check again or not
    # 
    # @param [Time] current_time The current time.  This gets stored to determine when to refresh next
    # @return [Array] an array of tuples that are cached on this var
    def refresh(current_time=Time.now)
      @tuples = @storage.read(@name)
      @last_checked_at = current_time
      @tuples
    end
    
    ##
    # Iterates through all known pending tuples and adjusts their active time
    #  to fixup any discrepencies due to writes into the system.  This most
    #  normally occurs when a scheduled change is far in the future and another
    #  value is written to storage in between the scheduled change and the
    #  current value.  Given that the tick size can change with any tuple, you
    #  could produce an invalid tuple state
    # 
    def reschedule
      # get non-old tuples
      # iterate through them, rescheduling
    end
    
    ##
    # The time at which this var should be checked against the database for any 
    # recorded changes.  The current value of the var is used to determine the 
    # tick size, and the next_check_at will be at the next tick (using the 
    # current values active_at to determine the starting point)
    # 
    # @param [Time] active_time The time to use for determining "now".
    # @return [Time,nil] the next time that the storage system will be checked 
    def next_check_at(active_time=Time.now)
      time_base, value, tick_size = *active_tuple(active_time)
      remainder  = (active_time - time_base).to_i % tick_size
      remainder == 0 ? active_time + tick_size : (active_time + tick_size - remainder)
    end
    
    ##
    # The soonest time at which a new value for this var could become active. 
    # The soonest a value can change is #next_check_at plus the tick_size for 
    # the current value.  Note, this value does not take into account any 
    # scheduled changes to the var, so setting a value at this returned time 
    # does not guarantee success. See #set for documentation on why it can fail
    # 
    # @param [Time] active_time The time to use for determining "now".
    # @return [Time,nil] the next time that the storage system will be checked 
    def next_available_change_at(active_time=Time.now)
      next_check_at(active_time) + tick_size(active_time)
    end

    private
    def active_tuple(current_time)
      found = @tuples.reverse.find do |tuple|
        active_at, value, check_time = *tuple
        active_at <= current_time
      end
      
      found || [EPOCH, nil, @default_tick_size]
    end

    def next_tuple(current_time)
      @tuples.find do |tuple|
        active_at, value, check_time = *tuple
        active_at > current_time
      end
      
      found || [EPOCH, nil, @default_tick_size]
    end
    
    def tick_size(current_time)
      active_tuple(current_time)[2]
    end

  end
end