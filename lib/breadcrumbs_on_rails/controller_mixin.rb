#--
# Breadcrumbs On Rails
#
# A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation.
#
# Copyright (c) 2009-2011 Simone Carletti <weppos@weppos.net>
#++

module BreadcrumbsOnRails

  module ControllerMixin
    extend ActiveSupport::Concern

    included do
      extend          ClassMethods
      include         InstanceMethods
      helper          HelperMethods
      helper_method   :add_breadcrumb, :breadcrumbs
    end

    module Utils

      def self.instance_proc(string)
        if string.kind_of?(String)
          proc { |controller| controller.instance_eval(string) }
        else
          string
        end
      end

      # This is an horrible method with an horrible name.
      #
      #   convert_to_set_of_strings(nil, [:foo, :bar])
      #   # => nil
      #   convert_to_set_of_strings(true, [:foo, :bar])
      #   # => ["foo", "bar"]
      #   convert_to_set_of_strings(:foo, [:foo, :bar])
      #   # => ["foo"]
      #   convert_to_set_of_strings([:foo, :bar, :baz], [:foo, :bar])
      #   # => ["foo", "bar", "baz"]
      #
      def self.convert_to_set_of_strings(value, keys)
        if value == true
          keys.map(&:to_s).to_set
        elsif value
          Array(value).map(&:to_s).to_set
        end
      end

    end

    module ClassMethods

      def add_breadcrumb_for_current(name, options = {}, &block)
        add_breadcrumb(name, nil, options, &block)
      end

      def add_breadcrumb(name, path, filter_options = {}, &block)
        # This isn't really nice here
        if eval = Utils.convert_to_set_of_strings(filter_options.delete(:eval), %w(name path))
          name = Utils.instance_proc(name) if eval.include?("name")
          unless path.nil?
            path = Utils.instance_proc(path) if eval.include?("path")
          end
        end

        before_filter(filter_options) do |controller|
          # if path isn't defined, use current path
          path = request.fullpath if path.nil?

          controller.send(:add_breadcrumb, name, path, filter_options, &block)
        end
      end

      # define breadcrumbs in a block
      def define_breadcrumb(breadcrumb = nil, &block)
        before_filter do |controller|
          controller.send(:define_breadcrumb, breadcrumb, &block)
        end
      end

    end

    module InstanceMethods
      protected

      # define volatile breadcrumbs in a block
      def define_volatile_breadcrumb(breadcrumb = nil, &block)
        #options[:breadcrumb] = breadcrumb
        breadcrumb = volatile_breadcrumbs(breadcrumb)
        definer = BreadcrumbsOnRails::BreadcrumbsDefiner.new(breadcrumb)
        #yield breadcrumb if block_given?
        yield definer if block_given?
      end
      alias :define_breadcrumb :define_volatile_breadcrumb

      # return volatile breadcrumbs defined in the current instance
      def volatile_breadcrumbs(breadcrumb = nil)
        breadcrumb = :default if breadcrumb.nil? 
        @breadcrumbs ||= {}
        @breadcrumbs[breadcrumb] ||= []
      end

      # return static breadcrumbs defined in the configuration
      def static_breadcrumbs(breadcrumb = nil)
        BreadcrumbsOnRails.static_breadcrumbs(breadcrumb)
      end

      # add a static breadcrumb, which will be kept for next instances
      def add_static_breadcrumb(name, path, options = {}, &block)
        breadcrumb = options[:breadcrumb]
        BreadcrumbsOnRails.add_breadcrumb_to(static_breadcrumbs(breadcrumb), name, path, options, &block)
      end

      # add a volatile breadcrumb, only valid in the current instances
      def add_volatile_breadcrumb(name, path, options = {}, &block)
        breadcrumb = options[:breadcrumb]
        BreadcrumbsOnRails.add_breadcrumb_to(volatile_breadcrumbs(breadcrumb), name, path, options, &block)
      end
      alias :add_breadcrumb :add_volatile_breadcrumb

      # return all defined breadcrumbs, static ones first then volatile ones
      def breadcrumbs(breadcrumb = nil)
        static_breadcrumbs(breadcrumb) + volatile_breadcrumbs(breadcrumb)
      end
    end

    module HelperMethods

      def render_breadcrumbs(options = {}, &block)
        builder = (options.delete(:builder) || Breadcrumbs::SimpleBuilder).new(self, breadcrumbs(options[:breadcrumb]), options)
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
