# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{breadcrumbs_on_rails}
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Simone Carletti"]
  s.date = %q{2011-04-30}
  s.description = %q{BreadcrumbsOnRails is a simple Ruby on Rails plugin for creating and managing a breadcrumb navigation for a Rails project.}
  s.email = %q{weppos@weppos.net}
  s.extra_rdoc_files = ["CHANGELOG.rdoc", "README.rdoc"]
  s.files = ["Rakefile", "LICENSE", "init.rb", "CHANGELOG.rdoc", "README.rdoc", "breadcrumbs_on_rails.gemspec", "lib/breadcrumbs_on_rails", "lib/breadcrumbs_on_rails/breadcrumbs.rb", "lib/breadcrumbs_on_rails/controller_mixin.rb", "lib/breadcrumbs_on_rails/railtie.rb", "lib/breadcrumbs_on_rails/version.rb", "lib/breadcrumbs_on_rails.rb", "test/test_helper.rb", "test/unit", "test/unit/breadcrumbs_on_rails_test.rb", "test/unit/builder_test.rb", "test/unit/element_test.rb", "test/unit/simple_builder_test.rb"]
  s.homepage = %q{http://www.simonecarletti.com/code/breadcrumbs_on_rails}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<hanna>, [">= 0"])
      s.add_development_dependency(%q<rails>, ["~> 3.0.0"])
      s.add_development_dependency(%q<mocha>, ["~> 0.9.10"])
    else
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<hanna>, [">= 0"])
      s.add_dependency(%q<rails>, ["~> 3.0.0"])
      s.add_dependency(%q<mocha>, ["~> 0.9.10"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<hanna>, [">= 0"])
    s.add_dependency(%q<rails>, ["~> 3.0.0"])
    s.add_dependency(%q<mocha>, ["~> 0.9.10"])
  end
end
