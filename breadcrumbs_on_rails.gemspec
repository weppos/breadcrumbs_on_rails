# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{breadcrumbs_on_rails}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Simone Carletti"]
  s.date = %q{2010-05-11}
  s.description = %q{    BreadcrumbsOnRails is a simple Ruby on Rails plugin for creating and managing     a breadcrumb navigation for a Rails project.     It provides helpers for creating navigation elements with a flexible interface.
}
  s.email = %q{weppos@weppos.net}
  s.extra_rdoc_files = ["CHANGELOG.rdoc", "LICENSE.rdoc", "README.rdoc"]
  s.files = ["Rakefile", "Manifest", "init.rb", "CHANGELOG.rdoc", "LICENSE.rdoc", "README.rdoc", "test", "lib", "rails/init.rb"]
  s.homepage = %q{http://www.simonecarletti.com/code/breadcrumbs_on_rails}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
