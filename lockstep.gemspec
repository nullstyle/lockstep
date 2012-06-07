# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lockstep/version"

Gem::Specification.new do |s|
  s.name        = "lockstep"
  s.version     = Lockstep::VERSION
  s.authors     = ["Scott Fleckenstein"]
  s.email       = ["nullstyle@gmail.com"]
  s.homepage    = "https://github.com/nullstyle/lockstep"
  s.summary     = %q{coordinate distributed values cheaply and predicatbly}
  s.description = %q{A library to coordinate distributed values cheaply and predicatbly}

  s.required_ruby_version = '>= 1.9.0'

  s.rubyforge_project = "lockstep"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  
  
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", ">= 2.9.0"
  s.add_development_dependency "rr"
  
  s.add_development_dependency "redis"

end
