require 'spec_helper'

module Lockstep
  describe Var do
    before(:each) do 
      @storage = Storage::Memory.new
      @time_base = Time.now  
      @tick_size = 10
    end
    
    subject do
      Var.new(@storage, "foo", @tick_size)
    end
  
    describe "#get" do
      it "should return nil if no value has ever been set" do
        subject.get.should eq(nil)
      end
      
      it "should return nil if no tuples stored could be considered active" do
        @storage.write("foo", @time_base + 1 , 10, @tick_size)
        subject.get(@time_base).should be_nil
      end
      
      it "should refresh the cached set of tuples if needed" do
        mock(subject).refresh_if_needed
        subject.get 
      end
      
      it "should return the newest value (based upon active_at) that is active" do
        @storage.write("foo", @time_base - 10, 10, @tick_size)
        @storage.write("foo", @time_base - 5, 20, @tick_size)
        subject.get(@time_base).should eq(20)
      end
      
      it "should return a value that is made active on the second it becomes available" do
        @storage.write("foo", @time_base, 10, @tick_size)
        subject.get(@time_base).should eq(10)
      end
      
      
      it "should return the oldest active value, even if a future value is scheduled" do
        @storage.write("foo", @time_base, 10, @tick_size)
        @storage.write("foo", @time_base + 1, 20, @tick_size)
        subject.get(@time_base).should eq(10)
      end
    end
    
    describe "#set" do
      
      
    end
    
    describe "#next_check_at" do
      before(:each){ @storage.write("foo", @time_base, 10, @tick_size) }
      
      it "should return a Time value" do
        subject.next_check_at.should be_instance_of(Time)
      end
            
      it "should return the current_time + 1 tick if the current_time is on a tick boundary" do
        subject.next_check_at(@time_base).should == @time_base + @tick_size
        subject.next_check_at(@time_base + 10).should == @time_base + (@tick_size * 2)
      end
      
      it "should return the current_time + (1 tick - tick size) if the current_time is not on a tick boundary" do
        subject.next_check_at(@time_base + 3).should == @time_base + @tick_size
        subject.next_check_at(@time_base + 13).should == @time_base + (@tick_size * 2)
      end
      
    end
    
    describe "#next_available_change_at" do
      
      it "should return a Time value" do
        subject.next_available_change_at.should be_instance_of(Time)
      end
      
    end
    
    describe "#refresh" do
      
      it "should set last_checked_at to the current_time" do
        subject.refresh(@time_base)
        subject.last_checked_at.should == @time_base
      end
      
      it "should load tuples from storage" do
        subject # initialize the subject so we don't get double read
        mock(@storage).read("foo")
        subject.refresh(@time_base)
      end
      
      it "should overwrite the old tuples with the new values" do
        orig = subject.tuples
        @storage.write("foo", @time_base, 10, @tick_size)
        subject.refresh(@time_base)
        subject.tuples.should_not == orig
      end
      
    end
    describe "#refresh_if_needed" do
    
      it "should call to refresh if the current_time is >= the next_check_time from the last_check_time" do
        subject.refresh(@time_base)
        check_time = @time_base + @tick_size
        
        mock(subject).refresh(check_time)
        subject.refresh_if_needed(check_time)
      end
    
      it "should not call to refresh if current_time < the next scheduled check time" do
        
        mock(subject).refresh.never
        subject.refresh_if_needed(@time_base)
      end
    end
  end
end

