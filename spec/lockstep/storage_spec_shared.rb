require 'spec_helper'

shared_context "storage_specs" do
  before(:each) do
    @time_base = Time.now
  end
  
  describe "#read" do
    before(:each) do
      subject.write("good_key", @time_base, 10, 10)
      subject.write("good_key", @time_base + 100, 20, 10)
    end
    
    it "should return an empty array if the provided key is not found" do
      subject.read("bad_key").should == []
    end
    
    it "should return all the stored tuple entries for a key" do
       subject.read("good_key").should eq([
         [@time_base, 10, 10],
         [@time_base + 100, 20, 10],
       ])
    end
    
    
    it "should return tuples in sorted order by timestamp" do
       subject.write("good_key", @time_base + 40, 30, 10)
       subject.read("good_key").should eq([
         [@time_base, 10, 10],
         [@time_base + 40, 30, 10],
         [@time_base + 100, 20, 10],
       ])
    end
    
  end
  
  
  describe "#write" do
    it "should return :added when a tuple is written for a previosuly unknown var" do
      subject.write("new_key", @time_base, 10, 10).should eq(:added)
    end
    
    it "should return :updated when a tuple is written for an existing tuple" do
      subject.write("key", @time_base, 10, 10)
      subject.write("key", @time_base, 20, 10).should eq(:updated)
    end
    
    it "should replace a tuple at the given active_at time if one already exists" do
      subject.write("key", @time_base, 10, 10)
      subject.write("key", @time_base, 20, 10)
      subject.read("key").should eq([[@time_base, 20, 10]])
    end
    
    it "should properly record a single tuple into the storage system" do
      subject.write("key", @time_base, 10, 10)
      subject.read("key").should eq([[@time_base, 10, 10]])
    end
    
    
    it "should return multiple tuples into the storage system" do
      subject.write("key", @time_base + 100, 20, 10)
      subject.write("key", @time_base, 10, 10)

      subject.read("key").should eq([
        [@time_base, 10, 10],
        [@time_base + 100, 20, 10],
      ])
    end
    
  end
  
  describe "#remove" do
    it "should return :not_found if the key is not known" do
      subject.remove("bad_key", @time_base).should eq(:not_found)
    end
    
    it "should return :not_found if the there is no" do
      subject.write("key", @time_base, 30, 10)
      subject.remove("key", @time_base + 10).should eq(:not_found)
    end
    
    it "should return :removed if the tuple was successfully removed" do
      subject.write("key", @time_base, 30, 10)
      subject.remove("key", @time_base).should eq(:removed)
    end
    
    
    it "should properly remove tuples" do
      subject.write("key", @time_base, 30, 10)
      subject.read("key").should eq([[@time_base, 30, 10]])
      subject.remove("key", @time_base).should eq(:removed)
      subject.read("key").should eq([])
    end
  
  end
end