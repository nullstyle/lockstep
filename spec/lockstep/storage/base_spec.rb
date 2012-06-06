require 'spec_helper'

describe Lockstep::Storage::Base do
  describe "#read" do
    it "should raise a runtime error" do
       expect { subject.read("my_key") }.to raise_error
    end
  end  
  
  describe "#remove" do
    it "should raise a runtime error" do
       expect { subject.remove("my_key", Time.now) }.to raise_error
    end
  end
  
  describe "#write" do
    it "should raise a runtime error" do
       expect { subject.write("my_key", Time.now, 3, 10) }.to raise_error
    end
  end
end