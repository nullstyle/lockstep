require 'lockstep'
require 'redis'

VAR_NAME = "my_var"

redis   = Redis.new
storage = Lockstep::Storage::Redis.new(redis)
locker  = Lockstep::Locker.new(storage)

var = locker.var VAR_NAME

loop do
  puts var.get.inspect

  sleep 1
end