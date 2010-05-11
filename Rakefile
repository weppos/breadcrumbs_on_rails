require "rubygems"
require "rake/testtask"
require "rake/rdoctask"
require "rake/gempackagetask"

$:.unshift(File.dirname(__FILE__) + "/lib")
require 'breadcrumbs_on_rails'


PKG_NAME    = ENV['PKG_NAME']    || BreadcrumbsOnRails::GEM
PKG_VERSION = ENV['PKG_VERSION'] || BreadcrumbsOnRails::VERSION

if ENV['SNAPSHOT'].to_i == 1
  PKG_VERSION << "." << Time.now.utc.strftime("%Y%m%d%H%M%S")
end


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

# Run test by default.
task :default => ["test"]

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|

  s.name              = PKG_NAME
  s.version           = PKG_VERSION
  s.summary           = "A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation."
  s.author            = "Simone Carletti"
  s.email             = "weppos@weppos.net"
  s.homepage          = "http://www.simonecarletti.com/code/breadcrumbs_on_rails"
  s.description       = <<-EOD
    BreadcrumbsOnRails is a simple Ruby on Rails plugin for creating and managing \
    a breadcrumb navigation for a Rails project. \
    It provides helpers for creating navigation elements with a flexible interface.
  EOD

  s.has_rdoc          = true
  # You should probably have a README of some kind. Change the filename
  # as appropriate
  s.extra_rdoc_files  = Dir.glob("*.rdoc")
  s.rdoc_options      = %w(--main README.rdoc)

  # Add any extra files to include in the gem (like your README)
  s.files             = %w(Rakefile init.rb) + Dir.glob("*.{rdoc,gemspec}") + Dir.glob("{test,lib,rails}/**/*")
  s.require_paths     = ["lib"]

  # If you want to depend on other gems, add them here, along with any
  # relevant versions
  # s.add_dependency("some_other_gem", "~> 0.1.0")

  # If your tests use any gems, include them here
  # s.add_development_dependency("mocha") # for example
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

begin
  require "rcov/rcovtask"

  desc "Create a code coverage report."
  Rcov::RcovTask.new do |t|
    t.test_files = FileList["test/**/*_test.rb"]
    t.ruby_opts << "-Itest -x mocha,rcov,Rakefile"
    t.verbose = true
  end
rescue LoadError
  task :clobber_rcov
  puts "RCov is not available"
end

begin
  require "code_statistics"

  desc "Show library's code statistics"
  task :stats do
    CodeStatistics.new(["BreadcrumbsOnRails", "lib"],
                       ["Tests", "test"]).to_s
  end
rescue LoadError
  puts "CodeStatistics (Rails) is not available"
end
