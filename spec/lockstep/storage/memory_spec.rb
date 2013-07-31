require 'spec_helper'
require 'lockstep/storage_spec_shared'

describe Lockstep::Storage::Memory do
  it_should_behave_like "storage back end"
end

