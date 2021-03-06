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
  s.add_development_dependency "yard"
  s.add_development_dependency "rspec", ">= 2.14.0"
  s.add_development_dependency "rspec-given", ">= 3.1.0"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-spork"
  s.add_development_dependency "coolline"
  s.add_development_dependency "growl"
  s.add_development_dependency "rb-fsevent"
  
  s.add_development_dependency "redis"
  s.add_development_dependency "pry"

end
