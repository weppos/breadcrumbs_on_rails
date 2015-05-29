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
    # To use it, pass the option :builder => BreadcrumbsOnRails::Breadcrumbs::SimpleBuilder to the <tt>render_breadcrumbs</tt> helper method.
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
          content = @context.link_to(compute_name(element), compute_path(element), element.options)
        end
        if @options[:tag]
          @context.content_tag(@options[:tag], content)
        else
          content
        end
      end

    end

    # The MicrodataBuilder is the default breadcrumb duilder.
    # It construct the breadcrumbs according to http://data-vocabulary.org/Breadcrumb
    class MicrodataBuilder < Builder

      def render
        @elements.collect do |element|
          render_element(element)
        end.join(@options[:separator] || '<span class="breadcrumbs-separator">&raquo;</span>')
      end

      def render_element(element)
        url = (compute_path(element).present? ? compute_path(element) : '#')
        subcontent = @context.content_tag(:span, compute_name(element), :itemprop => 'title')
        content = @context.link_to(subcontent, url, element.options.merge({:itemprop => 'url', :title => compute_name(element)}))
        @context.content_tag(:div, content, :itemscope => "", :itemtype => "http://data-vocabulary.org/Breadcrumb")
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
