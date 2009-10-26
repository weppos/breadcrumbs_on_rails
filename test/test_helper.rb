require 'rubygems'
gem     'rails', '~>2.3.0'
gem     'mocha', '~>0.9.7'

# Remember! Due to some Mocha internal changes,
# Rails 2.2.x requires Mocha 0.9.5 and
# Rails 2.3.x requires Mocha 0.9.7 
# gem     'rails', '2.2.2'
# gem     'mocha', '0.9.5'

require 'mocha'
require 'test/unit'
require 'active_support'
require 'action_controller'
require 'action_controller/cgi_ext'
require 'action_controller/test_process'
require 'action_view/test_case'

$:.unshift File.dirname(__FILE__) + '/../lib'
require    File.dirname(__FILE__) + '/../init.rb'

RAILS_ROOT = '.'    unless defined? RAILS_ROOT
RAILS_ENV  = 'test' unless defined? RAILS_ENV

ActionController::Base.logger = nil
ActionController::Routing::Routes.reload rescue nil
