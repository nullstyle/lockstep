require 'spec_helper'

module Lockstep
  describe Var do
    before(:each) do 
      @storage = Storage::Memory.new
      @time_base = Time.now  
    end
    
    subject do
      Var.new(@storage, "foo", 10)
    end
  
    describe "#get" do
      it "should return nil if no value has ever been set" do
        subject.get.should eq(nil)
      end
      
      it "should return nil if no tuples stored could be considered active" do
        @storage.write("foo", @time_base + 1 , 10, 10)
        subject.get(@time_base).should be_nil
      end
      
      it "should refresh the cached set of tuples if needed" do
        mock(subject).refresh_if_needed
        subject.get 
      end
      
      it "should return the newest value (based upon active_at) that is active" do
        @storage.write("foo", @time_base - 10, 10, 10)
        @storage.write("foo", @time_base - 5, 20, 10)
        subject.get(@time_base).should eq(20)
      end
      
      it "should return a value that is made active on the second it becomes available" do
        @storage.write("foo", @time_base, 10, 10)
        subject.get(@time_base).should eq(10)
      end
      
      
      it "should return the oldest active value, even if a future value is scheduled" do
        @storage.write("foo", @time_base, 10, 10)
        @storage.write("foo", @time_base + 1, 20, 10)
        subject.get(@time_base).should eq(10)
      end
    end
    
    describe "#set" do
      
      
    end
    
    describe "#next_check_at" do
      before(:each){ @storage.write("foo", @time_base, 10, 10) }
      
      it "should return a Time value" do
        subject.next_check_at.should be_instance_of(Time)
      end
            
      it "should return the current_time + 1 tick if the current_time is on a tick boundary" do
        subject.next_check_at(@time_base).should == @time_base + 10
        subject.next_check_at(@time_base + 10).should == @time_base + 20
      end
      
      it "should return the current_time + (1 tick - tick size) if the current_time is not on a tick boundary" do
        subject.next_check_at(@time_base + 3).should == @time_base + 10
        subject.next_check_at(@time_base + 13).should == @time_base + 20
      end
      
    end
    
  end  
end

