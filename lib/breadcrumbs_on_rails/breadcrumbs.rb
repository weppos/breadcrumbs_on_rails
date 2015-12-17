#--
# Breadcrumbs On Rails
#
# A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++

module BreadcrumbsOnRails

  module Breadcrumbs

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
      # @param [ActionView::Base] context The view context.
      # @param [Array<Element>] elements The collection of Elements.
      # @param [Hash] options Hash of options to customize the rendering behavior.
      #
      def initialize(context, elements, options = {})
        @context  = context
        @elements = elements
        @options  = options
      end

      # Renders Elements and returns the Breadcrumb navigation for the view.
      #
      # @return [String] The result of the breadcrumb rendering.
      #
      # @abstract You must implement this method in your custom Builder.
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
    #
    class SimpleBuilder < Builder

      def render
        @elements.collect do |element|
          render_element(element)
        end.join(@options[:separator] || " &raquo; ")
      end

      def render_element(element)

        p "element.options"
        p element.options

        element_options = element.options.except(:append, :prepend)
        p "element_options"
        p element_options



        # TODO Get prepend option
        if element.options[:prepend]
          # element.options.delete(:prepend)
        end

        # TODO get append option
        if element.options[:append]
          # element.options.delete(:append)
        end
        p "after delets element.options"
        p element.options
        p "after delets element_options"
        p element_options

        if element.path == nil
          content = compute_name(element)
        else
          content = @context.link_to_unless_current(compute_name(element), compute_path(element), element.options.except(:append, :prepend))
        end


        # TODO add prepend option to content
        if element.options[:prepend]
          case prepend = element.options[:prepend]
            when String
              content = prepend.to_s.html_safe + content
            when Proc
              content = prepend.call.to_s.html_safe + content
          end
          content
        end

        # TODO add append option to content
        if element.options[:append]
          case append = element.options[:append]
            when String
              content = content + append.to_s.html_safe
            when Proc
              content = content + append.call.to_s.html_safe
          end
          content
        end


        if @options[:tag]
          @context.content_tag(@options[:tag], content)
        else
          content
        end
      end

    end


    # Represents a navigation element in the breadcrumb collection.
    #
    class Element

      # @return [String] The element/link name.
      attr_accessor :name
      # @return [String] The element/link URL.
      attr_accessor :path
      # @return [Hash] The element/link URL.
      attr_accessor :options

      # Initializes the Element with given parameters.
      #
      # @param  [String] name The element/link name.
      # @param  [String] path The element/link URL.
      # @param  [Hash] options The element/link URL.
      # @return [Element]
      #
      def initialize(name, path = nil, options = {})
        self.name     = name
        self.path     = path
        self.options  = options
      end
    end

  end

end
