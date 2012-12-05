# The SimpleBuilder is the default breadcrumb builder.
# It provides basic functionalities to render a breadcrumb navigation.
#
# The SimpleBuilder accepts a limited set of options.
# If you need more flexibility, create a custom Builder and
# pass the option :builder => BuilderClass to the <tt>render_breadcrumbs</tt> helper method.
#
module BreadcrumbsOnRails
  module Breadcrumbs
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
          content
        end
      end

    end
  end
end
