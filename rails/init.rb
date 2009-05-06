require 'breadcrumbs_on_rails'

ActionController::Base.send :include, BreadcrumbsOnRails::ControllerMixin

RAILS_DEFAULT_LOGGER.info("** BreadcrumbsOnRails: initialized properly")
