#--
# Breadcrumbs On Rails
#
# A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++

module BreadcrumbsOnRails

  class Railtie < Rails::Railtie
    config.before_configuration do
      ActiveSupport.on_load(:action_controller) do
        include BreadcrumbsOnRails::ActionController
      end
    end
  end

end
