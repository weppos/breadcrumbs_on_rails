# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "breadcrumbs_on_rails"
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Simone Carletti"]
  s.date = "2012-02-03"
  s.description = "BreadcrumbsOnRails is a simple Ruby on Rails plugin for creating and managing a breadcrumb navigation for a Rails project."
  s.email = "weppos@weppos.net"
  s.files = [".gitignore", ".travis.yml", "Appraisals", "CHANGELOG.rdoc", "Gemfile", "Gemfile.lock", "LICENSE", "README.rdoc", "Rakefile", "breadcrumbs_on_rails.gemspec", "gemfiles/3.0.gemfile", "gemfiles/3.0.gemfile.lock", "gemfiles/3.1.gemfile", "gemfiles/3.1.gemfile.lock", "gemfiles/3.2.gemfile", "gemfiles/3.2.gemfile.lock", "init.rb", "lib/breadcrumbs_on_rails.rb", "lib/breadcrumbs_on_rails/breadcrumbs.rb", "lib/breadcrumbs_on_rails/controller_mixin.rb", "lib/breadcrumbs_on_rails/railtie.rb", "lib/breadcrumbs_on_rails/version.rb", "test/test_helper.rb", "test/unit/builder_test.rb", "test/unit/element_test.rb", "test/unit/simple_builder_test.rb"]
  s.homepage = "http://www.simonecarletti.com/code/breadcrumbs_on_rails"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation."
  s.test_files = ["test/test_helper.rb", "test/unit/builder_test.rb", "test/unit/element_test.rb", "test/unit/simple_builder_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rails>, [">= 3.0"])
      s.add_development_dependency(%q<appraisal>, [">= 0"])
      s.add_development_dependency(%q<mocha>, ["~> 0.9.10"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<rails>, [">= 3.0"])
      s.add_dependency(%q<appraisal>, [">= 0"])
      s.add_dependency(%q<mocha>, ["~> 0.9.10"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.0"])
    s.add_dependency(%q<appraisal>, [">= 0"])
    s.add_dependency(%q<mocha>, ["~> 0.9.10"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end
