# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'breadcrumbs_on_rails/version'

Gem::Specification.new do |spec|
  spec.name          = "breadcrumbs_on_rails"
  spec.version       = BreadcrumbsOnRails::VERSION
  spec.authors       = ["Simone Carletti"]
  spec.email         = ["weppos@weppos.net"]

  spec.summary       = %q{A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation}
  spec.description   = %q{BreadcrumbsOnRails is a simple Ruby on Rails plugin for creating and managing a breadcrumb navigation for a Rails project.}
  spec.homepage      = "https://simonecarletti.com/code/breadcrumbs_on_rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.0"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "rails", ">= 4.0"
  spec.add_development_dependency "mocha", ">= 1.0"
  spec.add_development_dependency "yard"
end
