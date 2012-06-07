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
      
      it "should return the oldest value (based upon active_at) that is active" do
        @storage.write("foo", @time_base -10, 10, 10)
        subject.get(@time_base).should eq(10)
      end
      
      it "should return the oldest active value, even if a future value is scheduled" do
        
      end
    end
  end  
end

