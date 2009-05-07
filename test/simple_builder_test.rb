require 'test_helper'

class SimpleBuilderTemplate
  include ActionView::Helpers::TagHelper

  def url_for(params)
    "http://localhost?" + params.to_param
  end

  protected

end


class SimpleBuilderTest < ActiveSupport::TestCase

  def setup
    @template = SimpleBuilderTemplate.new
    @element  = BreadcrumbsOnRails::Breadcrumbs::Element.new(nil, nil)
  end


  def test_render_should_be_implemented
    assert_nothing_raised { BreadcrumbsOnRails::Breadcrumbs::SimpleBuilder.new(@template, []).render }
  end


end
