#--
# Breadcrumbs On Rails
#
# A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation.
#
# Copyright (c) 2009-2020 Simone Carletti <weppos@weppos.net>
#++

module BreadcrumbsOnRails

  class Railtie < Rails::Railtie
    ActiveSupport.on_load(:action_controller) do
      ::ActionController::Base.send(:include, BreadcrumbsOnRails::ActionController)
    end
  end

end
