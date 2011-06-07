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
  
  module Breadcrumbs

    # 
    # = Builder
    #
    # The Builder class represents the abstract class for any custom Builder.
    #
    # To create a custom Builder, just extend this class
    # and implement the following abstract methods:
    #
    # * <tt>#render</tt>: Renders and returns the collection of navigation elements
    #
    class Builder

      # Initializes a new Builder with <tt>context</tt>,
      # <tt>element</tt> and <tt>options</tt>.
      #
      # * <tt>context</tt>:  The view context, that is current Rails Template instance
      # * <tt>elements</tt>: The collection of Elements
      # * <tt>options</tt>:  Hash with optional prefereces or settings to customize the rendering behavior
      #
      def initialize(context, elements, options = {})
        @context  = context
        @elements = elements
        @options  = options
      end

      # Renders Elements and returns the Breadcrumb navigation for the view.
      #
      # Raises <tt>NotImplemented</tt>: you should implement this method in your custom Builder.
      def render
        raise NotImplementedError
      end


      protected

        def compute_name(element)
          case name = element.name
            when Symbol
              @context.send(name)
            when Proc
              name.call(@context)
            else
              name.to_s
          end
        end

        def compute_path(element)
          case path = element.path
            when Symbol
              @context.send(path)
            when Proc
              path.call(@context)
            when Hash
              @context.url_for(path)
            else
              path.to_s
          end

        end

    end


    #
    # = SimpleBuilder
    #
    # The SimpleBuilder is the default breadcrumb builder.
    # It provides basic functionalities to render a breadcrumb navigation.
    #
    # The SimpleBuilder accepts a limited set of options.
    # If you need more flexibility, create a custom Builder and
    # pass the option :builder => BuilderClass to the <tt>render_breadcrumbs</tt> helper method.
    #
    class SimpleBuilder < Builder

      def render
        @elements.collect do |element|
          render_element(element)
        end.join(@options[:separator] || " &raquo; ")
      end

      def render_element(element)
        content = @context.link_to_unless_current(compute_name(h(element)), compute_path(element))
        if @options[:tag]
          @context.content_tag(@options[:tag], content)
        else
          content
        end
      end

    end


    # = Element
    #
    # Represents a navigation element in the breadcrumb collection.
    #
    class Element

      attr_accessor :name, :path

      def initialize(name, path)
        self.name = name
        self.path = path
      end

    end

  end

end
