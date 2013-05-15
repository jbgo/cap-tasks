# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cap_tasks/version'

Gem::Specification.new do |spec|
  spec.name          = "cap-tasks"
  spec.version       = CapTasks::VERSION
  spec.authors       = ["Jordan Bach"]
  spec.email         = ["jordanbach@gmail.com"]
  spec.description   = %q{A collection of reusable capistrano recipes.}
  spec.summary       = %q{A random of assortment of somewhat resusable capistrano recipes. Some environment-specific assumptions are made, so watch out for those!}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency 'capistrano'
end
