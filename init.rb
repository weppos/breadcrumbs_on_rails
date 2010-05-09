require 'breadcrumbs_on_rails'

ActionController::Base.send :include, BreadcrumbsOnRails::ControllerMixin

Rails.logger.info("** BreadcrumbsOnRails: initialized properly") if defined?(Rails)
