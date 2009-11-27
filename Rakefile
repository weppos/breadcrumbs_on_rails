$:.unshift(File.dirname(__FILE__) + "/lib")

require 'rubygems'
require 'rake'
require 'echoe'
require 'breadcrumbs_on_rails'


PKG_NAME    = ENV['PKG_NAME']    || BreadcrumbsOnRails::GEM
PKG_VERSION = ENV['PKG_VERSION'] || BreadcrumbsOnRails::VERSION
RUBYFORGE_PROJECT = nil

if ENV['SNAPSHOT'].to_i == 1
  PKG_VERSION << "." << Time.now.utc.strftime("%Y%m%d%H%M%S")
end


Echoe.new(PKG_NAME, PKG_VERSION) do |p|
  p.author        = "Simone Carletti"
  p.email         = "weppos@weppos.net"
  p.summary       = "A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation."
  p.url           = "http://code.simonecarletti.com/breadonrails"
  p.description   = <<-EOD
    BreadcrumbsOnRails is a simple Ruby on Rails plugin for creating and managing \
    a breadcrumb navigation for a Rails project. \
    It provides helpers for creating navigation elements with a flexible interface.
  EOD
  p.project       = RUBYFORGE_PROJECT

  p.need_zip      = true

  p.development_dependencies += ["rake  ~>0.8.7",
                                 "echoe ~>3.2.0"]

  p.rcov_options  = ["-Itest -x Rakefile,rcov,json,mocha,rack,actionpack,activesupport"]
end


begin
  require 'code_statistics'
  desc "Show library's code statistics"
  task :stats do
    CodeStatistics.new(["BreadcrumbsOnRails", "lib"],
                       ["Tests", "test"]).to_s
  end
rescue LoadError
  puts "CodeStatistics (Rails) is not available"
end
