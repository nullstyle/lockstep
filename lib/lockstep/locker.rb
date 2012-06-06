module Lockstep
  
  ##
  # The locker is essentially a factory/cache for Var objects.  It provides new var instances with the shared storage instance,
  # as well as providing a convenience method to refresh the values of all are vars created from the locker.
  # 
  class Locker
    attr_reader :storage

    def initialize(storage)
      @storage = storage
      @vars = {}
    end
    
    ##
    # Returns a reference to a lockstep variable
    #
    def var(name, tick_size)
      @vars[name] ||= Var.new(self, name, tick_size)
    end

    ##
    # Iterates through each registered var on this locker and reloads from the DB if needed
    #
    def refresh_if_needed
      @vars.values.each(&:refresh_if_needed)
    end
  end
end