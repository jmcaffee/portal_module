# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'portal_module/version'

Gem::Specification.new do |spec|
  spec.name          = "portal_module"
  spec.version       = PortalModule::VERSION
  spec.authors       = ["Jeff McAffee"]
  spec.email         = ["jeff@ktechsystems.com"]
  spec.summary       = %q{Portal Module CLI}
  spec.description   = %q{Command line interface for Portal Module}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "cucumber", "~> 1.3.9"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  #spec.add_development_dependency "pry-byebug", "~> 1.3.3"
  spec.add_development_dependency "pry", "~> 0.10"

  spec.add_runtime_dependency "nokogiri"
  spec.add_runtime_dependency "page-object"
  spec.add_runtime_dependency "thor"
<<<<<<< HEAD
=======
  spec.add_runtime_dependency "ktutils"
>>>>>>> b947a5d3cfb546e2133836adecd77d0487b4ff77
end
