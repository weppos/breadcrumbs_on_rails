require 'test/unit'
require 'mocha'
require 'dummy'

ENV["RAILS_ENV"] = "test"


$:.unshift File.expand_path('../../lib', __FILE__)
require 'breadcrumbs_on_rails'

ActionController::Base.view_paths = File.join(File.dirname(__FILE__), 'views')
