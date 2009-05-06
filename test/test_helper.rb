require 'rubygems'
require 'test/unit'

# FIXME: tests raises an error with Rails 2.3.2,
# althought this library is 100% compatible with Rails 2.3.x
gem     'rails', '2.2.2'

require 'active_support'
require 'active_support/test_case'
require 'action_controller'
require 'action_controller/cgi_ext'
require 'action_controller/test_process'
require 'action_view/test_case'
require 'mocha'

$:.unshift File.dirname(__FILE__) + '/../lib'

RAILS_ROOT = '.'    unless defined? RAILS_ROOT
RAILS_ENV  = 'test' unless defined? RAILS_ENV
RAILS_DEFAULT_LOGGER = Logger.new(STDOUT) unless defined? RAILS_DEFAULT_LOGGER

# simulate the inclusion as Rails does loading the init.rb file.
require    'breadcrumbs_on_rails'
require    File.dirname(__FILE__) + '/../init.rb'

ActionController::Base.logger = nil
ActionController::Routing::Routes.reload rescue nil

# Unit tests for Helpers are based on unit tests created and developed by Rails core team.
# See action_pack/test/abstract_unit for more details.
