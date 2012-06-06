# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lockstep/version"

Gem::Specification.new do |s|
  s.name        = "lockstep"
  s.version     = Lockstep::VERSION
  s.authors     = ["Scott Fleckenstein"]
  s.email       = ["nullstyle@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "lockstep"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", ">= 2.9.0"
  
  s.add_development_dependency "redis"

end
