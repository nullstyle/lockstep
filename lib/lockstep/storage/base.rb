module Lockstep
  module Storage
    ##
    # The storage system of lockstep is the simple persistence layer.
    # It provides the ability to:
    # 
    # 1. read all tuples for a given key
    # 2. write tuples
    # 3. remove tuples
    # 
    # Tuples are indexed from their active_at time.
    # Note:  The storage system is not responsible for the lockstep algorithm,
    # but merely provides the persistence mechanism from which the algorithm is
    # based.
    # 
    class Base
      ##
      # Returns all known tuples for this key
      #
      # @param [String] key the var to read the tuples of
      # @return [Array] the array of tuples, in order of active_at
      def read(key)
        raise "implement in subclass"
      end

      ##
      # Removes a tuple from the given key at the proved active_at time
      # 
      # @param [String] key
      # @param [Time] active_at The tuple index
      # @return [:removed,:not_found] :removed if the tuple was found and removed, otherwise :not_found
      def remove(key, active_at)
        raise "implement in subclass"
      end

      ##
      # Add, or replaces a tuple at the provided active_at time
      # 
      # @param [String] key
      # @param [Time] active_at The tuple index to write
      # @param [Object] value the value to store
      # @param [Fixnum] tick_size The tick size of this new value
      # @return [:added,:updated] :added if the active_at was not known, :updated if the tuple was replaced
      def write(key, active_at, value, tick_size)
        raise "implement in subclass"
      end
    end
  end
end