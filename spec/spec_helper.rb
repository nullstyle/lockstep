require 'rubygems'
require 'bundler/setup'
require 'spork'

Spork.prefork do
  require 'rspec'
  RSpec.configure do |config|
  
    config.before(:each) do
  
    end
  end
end



Spork.each_run do
  require 'lockstep'
end