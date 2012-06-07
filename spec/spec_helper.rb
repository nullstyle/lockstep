require 'rubygems'
require 'bundler/setup'

require 'lockstep' 

RSpec.configure do |config|
  config.mock_with :rr
  
  config.before(:each) do
  
  end
end
