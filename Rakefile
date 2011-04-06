require 'rubygems'
require 'bundler'
require 'rake/testtask'
require 'rake/gempackagetask'
require 'hanna/rdoctask'

$:.unshift(File.dirname(__FILE__) + "/lib")
require 'breadcrumbs_on_rails/version'


PKG_NAME    = ENV['PKG_NAME']    || "breadcrumbs_on_rails"
PKG_VERSION = ENV['PKG_VERSION'] || BreadcrumbsOnRails::VERSION

if ENV['SNAPSHOT'].to_i == 1
  PKG_VERSION << "." << Time.now.utc.strftime("%Y%m%d%H%M%S")
end


# Run test by default.
task :default => :test

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|
  s.name              = PKG_NAME
  s.version           = PKG_VERSION
  s.summary           = "A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation."
  s.description       = "BreadcrumbsOnRails is a simple Ruby on Rails plugin for creating and managing a breadcrumb navigation for a Rails project."

  s.author            = "Simone Carletti"
  s.email             = "weppos@weppos.net"
  s.homepage          = "http://www.simonecarletti.com/code/breadcrumbs_on_rails"

  # You should probably have a README of some kind. Change the filename
  # as appropriate
  s.extra_rdoc_files  = Dir.glob("*.rdoc")
  s.rdoc_options      = %w( --main README.rdoc )

  # Add any extra files to include in the gem (like your README)
  s.files             = %w( Rakefile LICENSE init.rb ) + Dir.glob("*.{rdoc,gemspec}") + Dir.glob("{lib,test,rails}/**/*")
  s.require_paths     = %w( lib )

  s.add_development_dependency("bundler")
  s.add_development_dependency("hanna")
  s.add_development_dependency("rails", "~> 3.0.6")
  s.add_development_dependency("mocha", "~> 0.9.10")
end

# This task actually builds the gem. We also regenerate a static
# .gemspec file, which is useful if something (i.e. GitHub) will
# be automatically building a gem for this project. If you're not
# using GitHub, edit as appropriate.
Rake::GemPackageTask.new(spec) do |pkg|
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
task :clobber => [:clobber_rdoc, :clobber_rcov, :clobber_package]

desc "Package the library and generates the gemspec"
task :package => [:gemspec]


# Run all the tests in the /test folder
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

# Generate documentation
Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("*.rdoc", "lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end


desc "Publish documentation to the site"
task :publish_rdoc => [:clobber_rdoc, :rdoc] do
  ENV["username"] || raise(ArgumentError, "Missing ssh username")
  sh "rsync -avz --delete rdoc/ #{ENV["username"]}@code:/var/www/apps/code/#{PKG_NAME}/api"
end
