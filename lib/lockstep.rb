require "lockstep/version"

module Lockstep
  autoload :Locker, "lockstep/locker"
  autoload :Var, "lockstep/var"

  module Storage
    autoload :Base, "lockstep/storage/base"
    autoload :Memory, "lockstep/storage/memory"
    autoload :Redis, "lockstep/storage/redis"
  end
end
