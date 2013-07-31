require 'spec_helper'

module Lockstep
  describe Var do
    Given!(:time_base){ Time.now  }

    Given(:storage)   { Storage::Memory.new }
    Given(:var_name)  { "foo" }
    Given(:tick_size) { 20 }

    Given(:old_value){ 10 }
    Given(:active_value){ 20 }
    Given(:future_value){ 30 }
    
    subject { Var.new(storage, var_name, tick_size) }
  
    describe "#get" do
      Given{ subject.stub(:refresh_if_needed).and_call_original }

      When(:result){ subject.get time_base }

      context "when no value has been set" do
        Then{ result.should be_nil }
        Then{ subject.should have_received(:refresh_if_needed) }
      end

      context "when no tuples stored could be considered active" do
        Given{ storage.write(var_name, time_base + 1 , future_value, tick_size) }
        Then{ result.should be_nil }
      end

      context "when two tuples are in storage" do


        Given do
          storage.write(var_name, time_base - 10, old_value, tick_size)
          storage.write(var_name, time_base - 5, active_value, tick_size)
          subject.refresh
        end

        Then{ result.should eq(active_value) }
      end

      context "when a tuple became active this second" do
        Given{ storage.write(var_name, time_base, active_value, tick_size) }
        Given{ subject.refresh }
        Then{ result.should eq(active_value) }
      end

      context "when a tuple exists in the future" do
        Given{ storage.write(var_name, time_base, active_value, tick_size) }
        Given{ storage.write(var_name, time_base + 1, future_value, tick_size) }
        Given{ subject.refresh }

        Then{ result.should eq(active_value) }
      end
    end
    
    describe "#set" do
      #TODO
    end
    
    describe "#next_check_at" do
      Given{ storage.write(var_name, time_base, active_value, tick_size) }
      Given(:args){[]}
      When(:result){ subject.next_check_at(*args) }
      Then{ result.should be_instance_of(Time) }

      context "when the provided time is current and on the tick boundary" do
        Given(:args){[time_base]}
        Then{ result.should eq(time_base + tick_size)}
      end

      context "when the provided time is in the future and on the tick boundary" do
        Given(:args){[time_base + tick_size]}
        Then{ result.should eq(time_base +  (tick_size * 2))}
      end


      context "when the provided time is in the future and not on a tick boundary" do
        Given(:args){[time_base + 3]}
        Then{ result.should eq(time_base + tick_size)}
      end


      context "when the provided time is more than one tick in the future and not on a tick boundary" do
        Given(:args){[time_base + tick_size + 3]}
        Then{ result.should eq(time_base + (tick_size * 2))}
      end      
    end
    
    describe "#next_available_change_at" do
      When(:result){ subject.next_available_change_at }
      Then{ result.should be_instance_of(Time) }
    end
    
    describe "#refresh" do
      Given!(:tuples_before_refresh){ subject.tuples }
      Given{ storage.stub(:read).and_call_original }
      Given{ storage.write(var_name, time_base, active_value, tick_size) }
      When{ subject.refresh(time_base) }

      Then{ subject.last_checked_at.should eq(time_base) }
      Then{ storage.should have_received(:read).with(var_name) }
      Then{ subject.tuples.should_not eq(tuples_before_refresh) }
    end

    describe "#refresh_if_needed" do

      Given(:current_time){ time_base }
      Given(:refresh_time){ time_base }
      Given{ subject.refresh(refresh_time) }

      Given{ subject.stub(:refresh).and_call_original }

      When{  subject.refresh_if_needed(current_time) }

      context "when the current_time is >= the next_check_time" do
        Given(:current_time){ subject.last_checked_at + tick_size }
        Then{ subject.should have_received(:refresh).with(current_time) }
        Then{ subject.last_checked_at.should eq(current_time) }
      end

      context "when the current_time is same as the last refresh time" do
        Given(:current_time){ refresh_time  }

        Then{ subject.should_not have_received(:refresh) }
        Then{ subject.last_checked_at.should eq(refresh_time) }
      end

      context "when the current_time is < the next scheduled check time" do
        Given(:current_time){ refresh_time + (tick_size - 1)}

        Then{ subject.should_not have_received(:refresh) }
        Then{ subject.last_checked_at.should eq(refresh_time) }
      end
    end
  end
end

