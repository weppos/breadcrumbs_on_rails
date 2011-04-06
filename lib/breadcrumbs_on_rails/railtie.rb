# 
# = Breadcrumbs On Rails
#
# A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation.
# 
#
# Category::    Rails
# Package::     BreadcrumbsOnRails
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


module BreadcrumbsOnRails

  class Railtie < Rails::Railtie
  end

end

ActionController::Base.send :include, BreadcrumbsOnRails::ControllerMixin
