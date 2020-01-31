#--
# Breadcrumbs On Rails
#
# A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation.
#
# Copyright (c) 2009-2016 Simone Carletti <weppos@weppos.net>
#++

module BreadcrumbsOnRails

  module ActionController
    extend ActiveSupport::Concern

    included do |base|
      extend          ClassMethods
      helper          HelperMethods
      helper_method   :add_breadcrumb, :breadcrumbs

      unless base.respond_to?(:before_action)
        base.alias_method :before_action, :before_filter
      end
    end

    protected

    def add_breadcrumb(name, path = nil, options = {})
      self.breadcrumbs << Breadcrumbs::Element.new(name, path, options)
    end

    def breadcrumbs
      @breadcrumbs ||= []
    end

    module ClassMethods

      def add_breadcrumb(name, path = nil, filter_options = {})
        element_options = filter_options.delete(:options) || {}

        before_action(filter_options) do |controller|
          controller.send(:add_breadcrumb, name, path, element_options)
        end
      end

    end

    module HelperMethods

      def render_breadcrumbs(options = {}, &block)
        builder = (options.delete(:builder) || Breadcrumbs::SimpleBuilder).new(self, breadcrumbs, options)
        content = builder.render.html_safe
        if block_given?
          capture(content, &block)
        else
          content
        end
      end

    end

  end

end
