module Lockstep
  ##
  # a Var is the main object within lockstep.  It implements the algorithm
  # described in the readme to provide a scaleable method of 
  # 
  class Var
    def initialize(locker, name, tick_size)
      @locker = locker
      @name = name
      @tick_size = tick_size

      refresh
    end
    
    def set(value, desired_active_time=Time.now, next_tick_size=@tick_size)
      
    end
    
    def get(active_time=Time.now)
      
    end

    def refresh_if_needed
      
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
      @locker.storage
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