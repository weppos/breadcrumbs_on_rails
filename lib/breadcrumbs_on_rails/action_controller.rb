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
      helper_method   :next_breadcrumbs, :breadcrumbs_list

      unless base.respond_to?(:before_action)
        base.alias_method :before_action, :before_filter
      end
    end

    protected

    def add_breadcrumb(name, path = nil, options = {})
      option_index = options.delete(:index)

      self.breadcrumbs(option_index) << Breadcrumbs::Element.new(name, path, options)
    end

    def breadcrumbs(index = nil)
      @breadcrumbs = self.breadcrumbs_list.last # for compatible to single breadcrumbs version. 
      if index
        self.breadcrumbs_list[index]
      else
        @breadcrumbs
      end
    end

    def next_breadcrumbs
      self.breadcrumbs_list << []
    end

    def breadcrumbs_list
      @breadcrumbs_list ||= [[]]
    end

    module Utils

      def self.instance_proc(string)
        if string.kind_of?(String)
          proc { |controller| controller.instance_eval(string) }
        else
          string
        end
      end

      # This is a horrible method with a horrible name.
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

      def add_breadcrumb(name, path = nil, filter_options = {})
        # This isn't really nice here
        if eval = Utils.convert_to_set_of_strings(filter_options.delete(:eval), %w(name path))
          name = Utils.instance_proc(name) if eval.include?("name")
          path = Utils.instance_proc(path) if eval.include?("path")
        end

        element_options = filter_options.delete(:options) || {}

        before_action(filter_options) do |controller|
          controller.send(:add_breadcrumb, name, path, element_options)
        end
      end

    end

    module HelperMethods

      def render_breadcrumbs(options = {}, &block)
        option_builder = options.delete(:builder)
        option_list_separator = options.delete(:list_separator)
        breadcrumbs_list.map do |bcs|
          builder = (option_builder || Breadcrumbs::SimpleBuilder).new(self, bcs, options)
          content = builder.render
          if block_given?
            capture(content, &block)
          else
            content
          end
        end.join(option_list_separator).html_safe
      end
    end

  end

end
