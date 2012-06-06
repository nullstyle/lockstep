require "set"

module Lockstep
  module Storage
    class Memory < Base

      class Tuple < Struct.new(:active_at, :value, :tick_size) ; end
      
      def initialize
        @data = {}
      end
        
      def read(key)
        tuples = @data[key] || []
        tuples.map(&:to_a)
      end

      def remove(key, active_at)
        tuples = @data[key] || []
        tuples.reject!{|tuple| tuple.active_at == active_at} == nil ? :not_found : :removed
      end

      
      def write(key, active_at, value, tick_size)
        tuples = @data[key] ||= []
        
        removal_status = remove(key, active_at)
        
        tuples << Tuple.new(active_at, value, tick_size)
        
        # sort ascending by active_at time
        tuples.sort! do |l,r|
          l.active_at <=> r.active_at
        end
        removal_status == :not_found ? :added : :updated
      end
    end
  end
end