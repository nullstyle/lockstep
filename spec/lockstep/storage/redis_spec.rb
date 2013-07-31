require 'spec_helper'
require 'lockstep/storage_spec_shared'

require 'redis'

describe Lockstep::Storage::Redis do
  subject do
    redis = ::Redis.new
    redis.flushdb
    Lockstep::Storage::Redis.new(redis)
  end
  
  it_should_behave_like "storage back end"
end

