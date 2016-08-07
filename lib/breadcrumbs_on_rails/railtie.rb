#--
# Breadcrumbs On Rails
#
# A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++

module BreadcrumbsOnRails

  class Railtie < Rails::Railtie
    initializer "breadcrumbs_on_rails.initialize" do
      ActiveSupport.on_load(:action_controller) do
        ::ActionController::Base.include BreadcrumbsOnRails::ActionController
      end
    end
  end

end
