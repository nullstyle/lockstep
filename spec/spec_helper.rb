require 'rubygems'
require 'bundler/setup'
require 'spork'

Spork.prefork do
  require 'rspec'
  RSpec.configure do |config|
    config.mock_with :rr
  
    config.before(:each) do
  
    end
  end
end



Spork.each_run do
  require 'lockstep'
end