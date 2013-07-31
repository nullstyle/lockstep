require 'spec_helper'

describe Lockstep::Storage::Base do
  describe "#read" do
    When(:result) { subject.read("my_key") }
    Then { result.should have_failed }
  end  
  
  describe "#remove" do
    When(:result) { subject.remove("my_key") }
    Then { result.should have_failed }
  end
  
  describe "#write" do
    When(:result) { subject.write("my_key") }
    Then { result.should have_failed }
  end
end