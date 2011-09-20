# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "breadcrumbs_on_rails"
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Simone Carletti"]
  s.date = "2011-09-20"
  s.description = "BreadcrumbsOnRails is a simple Ruby on Rails plugin for creating and managing a breadcrumb navigation for a Rails project."
  s.email = "weppos@weppos.net"
  s.files = [".gitignore", "CHANGELOG.rdoc", "Gemfile", "Gemfile.lock", "LICENSE", "README.rdoc", "Rakefile", "breadcrumbs_on_rails.gemspec", "init.rb", "lib/breadcrumbs_on_rails.rb", "lib/breadcrumbs_on_rails/breadcrumbs.rb", "lib/breadcrumbs_on_rails/controller_mixin.rb", "lib/breadcrumbs_on_rails/railtie.rb", "lib/breadcrumbs_on_rails/version.rb", "test/test_helper.rb", "test/unit/builder_test.rb", "test/unit/element_test.rb", "test/unit/simple_builder_test.rb"]
  s.homepage = "http://www.simonecarletti.com/code/breadcrumbs_on_rails"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation."
  s.test_files = ["test/test_helper.rb", "test/unit/builder_test.rb", "test/unit/element_test.rb", "test/unit/simple_builder_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<rails>, ["~> 3.0.0"])
      s.add_development_dependency(%q<mocha>, ["~> 0.9.10"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<rails>, ["~> 3.0.0"])
      s.add_dependency(%q<mocha>, ["~> 0.9.10"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<rails>, ["~> 3.0.0"])
    s.add_dependency(%q<mocha>, ["~> 0.9.10"])
  end
end
