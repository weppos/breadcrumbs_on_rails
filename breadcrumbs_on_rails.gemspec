# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "breadcrumbs_on_rails/version"

Gem::Specification.new do |spec|
  spec.name          = "breadcrumbs_on_rails"
  spec.version       = BreadcrumbsOnRails::VERSION
  spec.authors       = ["Simone Carletti"]
  spec.email         = ["weppos@weppos.net"]
  spec.homepage      = "https://simonecarletti.com/code/breadcrumbs_on_rails"
  spec.summary       = "A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation"
  spec.description   = "BreadcrumbsOnRails is a simple Ruby on Rails plugin for creating and managing a breadcrumb navigation for a Rails project."
  spec.licenses      = ["MIT"]

  spec.required_ruby_version = ">= 2.4"

  spec.require_paths = ["lib"]
  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.extra_rdoc_files = %w( LICENSE.txt )

  spec.add_dependency "railties", ">= 5.0"
end
