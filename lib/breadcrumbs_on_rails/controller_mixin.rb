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
# SVN: $Id$
#++


module BreadcrumbsOnRails
  
  module ControllerMixin
    
    def self.included(base)
      base.extend         ClassMethods
      base.send :helper,  HelperMethods
      base.class_eval do
        include       InstanceMethods
        helper        HelperMethods
        helper_method :add_breadcrumb, :breadcrumbs
      end
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
      # convert_to_set_of_strings(nil, [:foo, :bar])
      # # => nil
      # convert_to_set_of_strings(true, [:foo, :bar])
      # # => ["foo", "bar"]
      # convert_to_set_of_strings(:foo, [:foo, :bar])
      # # => ["foo"]
      # convert_to_set_of_strings([:foo, :bar, :baz], [:foo, :bar])
      # # => ["foo", "bar", "baz"]
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

      def add_breadcrumb(name, path, options = {})
        # This isn't really nice here
        if eval = Utils.convert_to_set_of_strings(options.delete(:eval), %w(name path))
          name = Utils.instance_proc(name) if eval.include?("name")
          path = Utils.instance_proc(path) if eval.include?("path")
        end

        before_filter(options) do |controller|
          controller.send(:add_breadcrumb, name, path)
        end
      end

    end

    module InstanceMethods
      protected

      def add_breadcrumb(name, path)
        self.breadcrumbs << Breadcrumbs::Element.new(name, path)
      end

      def breadcrumbs
        @breadcrumbs ||= []
      end

    end

    module HelperMethods

      def render_breadcrumbs(options = {})
        builder = (options.delete(:builder) || Breadcrumbs::SimpleBuilder).new(self, breadcrumbs, options)
        builder.render
      end  
      
    end
  
  end
  
end