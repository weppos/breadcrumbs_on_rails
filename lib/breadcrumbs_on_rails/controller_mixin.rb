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

    module ClassMethods

      def add_breadcrumb(name, path, options = {})
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