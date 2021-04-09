#--
# Breadcrumbs On Rails
#
# A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation.
#
# Copyright (c) 2009-2020 Simone Carletti <weppos@weppos.net>
#++

module BreadcrumbsOnRails

  module Breadcrumbs

    # The Builder class represents the abstract class for any custom Builder.
    #
    # To create a custom Builder, just extend this class
    # and implement the following abstract methods:
    #
    # * <tt>#render</tt>: Renders and returns the collection of navigation elements
    class Builder

      # Initializes a new Builder with <tt>context</tt>,
      # <tt>element</tt> and <tt>options</tt>.
      #
      # @param context [ActionView::Base] the view context
      # @param elements [Array<Element>] the collection of Elements
      # @param options [Hash] options to customize the rendering behavior
      def initialize(context, elements, options = {})
        @context  = context
        @elements = elements
        @options  = options
      end

      # Renders Elements and returns the Breadcrumb navigation for the view.
      #
      # @abstract You must implement this method in your custom Builder.
      # 
      # @return [String] the result of the breadcrumb rendering
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
        else
          @context.url_for(path)
        end
      end

    end


    # The SimpleBuilder is the default breadcrumb builder.
    # It provides basic functionalities to render a breadcrumb navigation.
    #
    # The SimpleBuilder accepts a limited set of options.
    # If you need more flexibility, create a custom Builder and
    # pass the option :builder => BuilderClass to the <tt>render_breadcrumbs</tt> helper method.
    class SimpleBuilder < Builder

      def render
        @elements.collect do |element|
          render_element(element)
        end.join(@options[:separator] || " &raquo; ")
      end

      def render_element(element)
        if element.path == nil
          content = compute_name(element)
        else
          content = @context.link_to_unless_current(compute_name(element), compute_path(element), element.options)
        end
        if @options[:tag]
          @context.content_tag(@options[:tag], content)
        else
          ERB::Util.h(content)
        end
      end

    end


    # Represents a navigation element in the breadcrumb collection.
    class Element

      # @return [String] the element/link name
      attr_accessor :name
      # @return [String] the element/link URL
      attr_accessor :path
      # @return [Hash] the element/link options
      attr_accessor :options

      # Initializes the Element with given parameters.
      #
      # @param  name [String] the element/link name
      # @param  path [String] the element/link URL
      # @param  options [Hash] the element/link options
      # @return [Element]
      def initialize(name, path = nil, options = {})
        self.name     = name
        self.path     = path
        self.options  = options
      end
    end

  end

end
