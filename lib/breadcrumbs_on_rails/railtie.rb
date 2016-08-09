#--
# Breadcrumbs On Rails
#
# A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation.
#
# Copyright (c) 2009-2016 Simone Carletti <weppos@weppos.net>
#++

module BreadcrumbsOnRails

  class Railtie < Rails::Railtie
    ActiveSupport.on_load(:action_controller) do
      # There is no need to include breadcrumbs on an API controller
      unless self.name == 'ActionController::API'
        include BreadcrumbsOnRails::ActionController
      end
    end
  end

end
