#--
# Breadcrumbs On Rails
#
# A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation.
#
# Copyright (c) 2009-2020 Simone Carletti <weppos@weppos.net>
#++

module BreadcrumbsOnRails

  module ActionController
    extend ActiveSupport::Concern

    included do |base|
      extend          ClassMethods
      helper          HelperMethods
      helper_method   :add_breadcrumb_on_rails, :add_breadcrumb,
                      :breadcrumbs_on_rails, :breadcrumbs

      unless base.respond_to?(:before_action)
        base.alias_method :before_action, :before_filter
      end
    end

    protected

    # Pushes a new breadcrumb element into the collection.
    #
    # @param  name [String]
    # @param  path [String, nil]
    # @param  options [Hash]
    # @return [void]
    def add_breadcrumb_on_rails(name, path = nil, options = {})
      breadcrumbs_on_rails << Breadcrumbs::Element.new(name, path, options)
    end
    alias add_breadcrumb add_breadcrumb_on_rails

    # Gets the list of all breadcrumb element in the collection.
    #
    # @return [Array<Breadcrumbs::Element>]
    def breadcrumbs_on_rails
      @breadcrumbs_on_rails ||= []
    end
    alias breadcrumbs breadcrumbs_on_rails


    module ClassMethods

      def add_breadcrumb_on_rails(name, path = nil, filter_options = {})
        element_options = filter_options.delete(:options) || {}

        before_action(filter_options) do |controller|
          controller.send(:add_breadcrumb, name, path, element_options)
        end
      end
      alias add_breadcrumb add_breadcrumb_on_rails

    end

    module HelperMethods

      def render_breadcrumbs(options = {}, &block)
        builder = (options.delete(:builder) || Breadcrumbs::SimpleBuilder).new(self, breadcrumbs_on_rails, options)
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
