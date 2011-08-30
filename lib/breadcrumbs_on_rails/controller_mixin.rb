# 
# = Breadcrumbs On Rails
#
# A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation.
# 
#
# Category::    Rails
# Package::     BreadcrumbsOnRails
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
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
        activ_klass = "activ"
        options[:klass] = [] unless options.has_key?(:klass)
        options[:klass] << activ_klass unless options[:klass].include?(activ_klass)
        add_breadcrumb(name, nil, options, &block)
      end

      def add_breadcrumb(name, path = nil, options = {}, &block)
        # This isn't really nice here
        if eval = Utils.convert_to_set_of_strings(options.delete(:eval), %w(name path))
          name = Utils.instance_proc(name) if eval.include?("name")
          if !path.nil?
            path = Utils.instance_proc(path) if eval.include?("path")
          end
        end

        before_filter(options) do |controller|
          if path.nil?
            path = request.fullpath
          end

          controller.send(:add_breadcrumb, name, path, options, &block)
        end
      end
    end

    module InstanceMethods
      protected

      def add_breadcrumb(name, path, options = {}, &block)
        #self.breadcrumbs << Breadcrumbs::Element.new(name, path)
        elem = Breadcrumbs::Element.new(name, path)

        # adding css classes
        elem.klass = options[:klass] if options.has_key?(:klass)

        yield elem if block_given?
        self.breadcrumbs << elem
      end

      def breadcrumbs
        @breadcrumbs ||= []
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
