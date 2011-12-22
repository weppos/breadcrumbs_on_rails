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
      helper_method   :add_breadcrumb, :breadcrumbs, :flags
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

      #
      # flags methods
      #

      # get flag value
      def get_flag(name, filter_options = {})
        before_filter(filter_options) do |controller|
          controller.send(:get_flag, name, filter_options)
        end
      end

      # set flag value
      def set_flag(name, value, filter_options = {})
        before_filter(filter_options) do |controller|
          controller.send(:set_flag, name, value, filter_options)
        end
      end

      # reset flag value
      def reset_flag(name, filter_options = {})
        before_filter(filter_options) do |controller|
          controller.send(:reset_flag, name, filter_options)
        end
      end

      #
      # breadcrumbs methods
      #

      # add a breadcrumb for the current page
      def add_breadcrumb_for_current(name, options = {}, &block)
        add_breadcrumb(name, nil, options, &block)
      end

      # add a breadcrumb
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

      # define volatile breadcrumbs/flags in a block
      def definer(name = nil, filter_options = {}, &block)
        before_filter(filter_options) do |controller|
          controller.send(:definer, name, filter_options, &block)
        end
      end
    end

    module InstanceMethods
      protected

      # common

      # getting static,volatile options
      def static_or_volatile(options)
        static = options[:static] || false
        volatile = options[:volatile] || false
        volatile = (volatile || ((static == false) && (volatile == false)))
        return static, volatile
      end

      def definer(name = nil, options = {}, &block)
        static, volatile = static_or_volatile(options)

        # breadcrumbs
        if static
          breadcrumb = static_breadcrumbs(name)
        else #if volatile
          breadcrumb = volatile_breadcrumbs(name)
        end
        # flags
        if static
          flags = static_flags(name)
        else #if volatile
          flags = volatile_flags(name)
        end

        # use a definer to allow block
        d = BreadcrumbsOnRails::BreadcrumbsDefiner.new(breadcrumb, flags, options)
        yield d if block_given?
      end

      # flags

      # get flag value
      def get_flag(name, options = {})
        # getting options
        static, volatile = static_or_volatile(options)

        f = static_flags(options[:flagset]) if static
        f = volatile_flags(options[:flagset]) if volatile
        f = flags(options[:flagset]) unless static || volatile

        f[name] if f.include?(name)
      end

      # reset flag value
      def reset_flag(name, options = {})
        set_flag(name, nil, options) unless name.nil?
      end

      # set flag value
      def set_flag(name, value = nil, options = {})
        # getting options
        static, volatile = static_or_volatile(options)

        # setting flag
        if static
          set_static_flag(name, value, options)
        else #if volatile
          # default is volatile when nothing's set
          set_volatile_flag(name, value, options)
        end
      end

      # add a static flag, which will be kept for next instances
      def set_static_flag(name, value, options = {})
        flagset = options[:flagset]
        BreadcrumbsOnRails.set_flag_in(static_flags(flagset), name, value, options)
      end

      # add a volatile flag, only valid in the current instances
      def set_volatile_flag(name, value, options = {})
        flagset = options[:flagset]
        BreadcrumbsOnRails.set_flag_in(volatile_flags(flagset), name, value, options)
      end

      # return volatile flags defined in the current instance
      def volatile_flags(flagset = nil)
        flagset = :default if flagset.nil? 
        @flags ||= {}
        @flags[flagset] ||= {}
        @flags[flagset]
      end
      # return static flags defined in the configuration
      def static_flags(flagset = nil)
        BreadcrumbsOnRails.static_flags(flagset)
      end
      # return all defined flags, static ones first then volatile ones
      def flags(flagset = nil)
        static_flags(flagset).merge(volatile_flags(flagset))
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
      # return all defined breadcrumbs, static ones first then volatile ones
      def breadcrumbs(breadcrumb = nil)
        static_breadcrumbs(breadcrumb) + volatile_breadcrumbs(breadcrumb)
      end
    end

    module HelperMethods

      def render_breadcrumbs(options = {}, &block)
        options[:flags] = flags(options[:breadcrumb])
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
