require 'rubygems'
require 'bundler'
require 'appraisal'

$:.unshift(File.dirname(__FILE__) + "/lib")
require 'breadcrumbs_on_rails/version'


PKG_NAME    = ENV['PKG_NAME']    || "breadcrumbs_on_rails"
PKG_VERSION = ENV['PKG_VERSION'] || BreadcrumbsOnRails::VERSION


# Run test by default.
task :default => :test

spec = Gem::Specification.new do |s|
  s.name              = PKG_NAME
  s.version           = PKG_VERSION
  s.summary           = "A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation."
  s.description       = "BreadcrumbsOnRails is a simple Ruby on Rails plugin for creating and managing a breadcrumb navigation for a Rails project."

  s.author            = "Simone Carletti"
  s.email             = "weppos@weppos.net"
  s.homepage          = "http://www.simonecarletti.com/code/breadcrumbs_on_rails"

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths     = %w( lib )

  s.add_development_dependency "rails", ">= 3.0"
  s.add_development_dependency "appraisal"
  s.add_development_dependency "mocha", "~> 0.9.10"
  s.add_development_dependency "yard"
end


require 'rubygems/package_task'

Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Build the gemspec file #{spec.name}.gemspec"
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

desc "Remove any temporary products, including gemspec."
task :clean => [:clobber] do
  rm "#{spec.name}.gemspec"
end

desc "Remove any generated file"
task :clobber => [:clobber_package]

desc "Package the library and generates the gemspec"
task :package => [:gemspec]


require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = !!ENV["VERBOSE"]
  t.warning = !!ENV["WARNING"]
end


require 'yard'
require 'yard/rake/yardoc_task'

YARD::Rake::YardocTask.new(:yardoc) do |y|
  y.options = ["--output-dir", "yardoc"]
end

namespace :yardoc do
  desc "Remove YARD products"
  task :clobber do
    rm_r "yardoc" rescue nil
  end
end

task :clobber => "yardoc:clobber"
