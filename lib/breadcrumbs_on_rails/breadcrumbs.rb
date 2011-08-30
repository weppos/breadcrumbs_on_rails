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
        content = @context.link_to_unless_current(compute_name(element), compute_path(element))

        # rendering sub-elements
        if (element.childs.length > 0)
          content = content + " |"
          element.childs.each do |child|
            content = content + @context.link_to_unless_current(compute_name(child), compute_path(child)) + "|"
          end
        end

        if @options[:tag]
          @context.content_tag(@options[:tag], content)
        else
          content
        end
      end

    end


    #
    # = HtmlBuilder
    #
    # The HtmlBuilder is an html5 breadcrumb builder.
    # It provides a simple way to render breadcrumb navigation as html5 tags.
    #
    # The SimpleBuilder accepts a limited set of options.
    # If you need more flexibility, create a custom Builder and
    # pass the option :builder => BuilderClass to the <tt>render_breadcrumbs</tt> helper method.
    #
    class HtmlBuilder < Builder

      def render
        # creating nav id=breadcrumb
        @context.content_tag(:nav, :id => 'breadcrumb') do
          render_elements(@elements)
        end
      end

      def render_elements(elements)
        content = nil
        elements.each do |element|
          if content.nil?
            content = render_element(element)
          else
            content << render_element(element)
          end
        end
        @context.content_tag(:ul, content)
      end

      def render_element(element)
        # preparing element
        if (element.childs.length > 0)
          content = @context.link_to(compute_path(element)) do
            @context.content_tag(:span, compute_name(element), :class => "arrow")
          end
        else
          content = @context.link_to(compute_name(element), compute_path(element))
        end

        # rendering sub-elements
        if element.childs.length > 0
          content = content + render_elements(element.childs)
          element.klass << "under_menu"
        end
        klass = element.klass.join(" ")

        # adding element and it's sub-elements
        @context.content_tag(:li, content, :class => klass)
      end

    end


    # = Element
    #
    # Represents a navigation element in the breadcrumb collection.
    #
    class Element

      attr_accessor :name, :path
      attr_accessor :klass
      attr_accessor :childs

      def initialize(name, path)
        self.name = name
        self.path = path
        self.childs = []
        self.klass = []
      end

      def add_child(name, path)
        self.childs << Breadcrumbs::Element.new(name, path)
      end

    end

  end

end
