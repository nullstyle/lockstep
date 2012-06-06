module Lockstep
  module Storage
    
    ##
    # The redis storage system uses a redis client to persist the tuples for a
    # given key.
    # 
    class Redis < Base

      def initialize(redis)
        @data = redis
      end
        
      def read(key)
        @data.zrange(key, 0, -1).map{|v| Marshal.load(v)}
      end
      
      def remove(key, active_at)
        items_removed = @data.zremrangebyscore(key, active_at.to_i, active_at.to_i) 
        items_removed == 0 ? :not_found : :removed
      end

      def write(key, active_at, value, tick_size)
       removal_status = remove(key, active_at)
       @data.zadd(key, active_at.to_i, Marshal.dump([active_at, value, tick_size]))
       removal_status == :not_found ? :added : :updated
      end
    end
  end
end