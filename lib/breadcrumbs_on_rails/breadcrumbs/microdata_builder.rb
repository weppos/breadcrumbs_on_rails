# The MicrodataBuilder is like the default breadcrumb builder.
# but it allows to inject microdata semantics in the HTML code.
# cf. http://www.data-vocabulary.org/Breadcrumb/
#
# You have to put this in your environment :
#     require 'breadcrumbs_on_rails/breadcrumbs/microdata_builder'
# then configure your renderer, like this :
#     <%= render_breadcrumbs(
#           :builder => BreadcrumbsOnRails::Breadcrumbs::MicrodataBuilder,
#         ).html_safe %>
#
module BreadcrumbsOnRails
  module Breadcrumbs
    class MicrodataBuilder < Builder
      def render
        @elements.collect do |element|
          render_element(element)
        end.join(@options[:separator] || " &raquo; ")
      end

      def render_element(element)
        url = (compute_path(element).present? ? compute_path(element) : '#')
        subcontent = @context.content_tag(:span, compute_name(element), :itemprop => 'title')
        content = @context.link_to_unless_current(subcontent, url, :itemprop => 'url')
        @context.content_tag(:span, content, :itemscope => "", :itemtype => "http://data-vocabulary.org/Breadcrumb")
      end  
    end
  end
end