require 'test/unit'
require 'mocha'

ENV["RAILS_ENV"] = "test"

require "active_support"
require "action_controller"
require "rails/railtie"

$:.unshift File.expand_path('../../lib', __FILE__)
require 'breadcrumbs_on_rails'

ActionController::Base.view_paths = File.join(File.dirname(__FILE__), 'views')

BreadcrumbsOnRails::Routes = ActionDispatch::Routing::RouteSet.new
BreadcrumbsOnRails::Routes.draw do
  match ':controller(/:action(/:id))'
end

ActionController::Base.send :include, BreadcrumbsOnRails::Routes.url_helpers
