require 'spec_helper'
require 'lockstep/storage_spec_shared'

require 'redis'

describe Lockstep::Storage::Redis do
  subject do
    redis = ::Redis.new
    redis.flushdb
    Lockstep::Storage::Redis.new(redis)
  end
  
  include_context "storage_specs"
end

