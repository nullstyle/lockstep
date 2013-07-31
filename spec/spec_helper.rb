require 'rubygems'
require 'bundler/setup'
require 'spork'
require 'pry'
require 'rspec/given'

Spork.prefork do
  require 'rspec'
  RSpec.configure do |config|
  

  end
end



Spork.each_run do
  require 'lockstep'
end