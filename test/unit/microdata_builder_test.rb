require 'test_helper'
require 'breadcrumbs_on_rails/breadcrumbs/microdata_builder'

class MicrodataBuilderTest < ActionView::TestCase

  def setup
    @template = self
  end


  def test_render_should_be_implemented
    assert_nothing_raised { microdata_builder(@template, []).render }
  end


  def test_render_with_0_elements
    assert_equal("", microdata_builder(@template, []).render)
  end

  def test_render_with_0_elements_and_separator
    assert_equal("", microdata_builder(@template, [], :separator => "-").render)
  end


  def test_render_with_1_element
    @template.expects(:current_page?).times(1).returns(false)
    assert_dom_equal("<span itemscope=\"\" itemtype=\"http://data-vocabulary.org/Breadcrumb\"><a href=\"/element/1\" itemprop=\"url\"><span itemprop=\"title\">Element 1</span></a></span>",
                     microdata_builder(@template, generate_elements(1)).render)
  end

  def test_render_with_1_element_and_separator
    @template.expects(:current_page?).times(1).returns(false)
    assert_dom_equal("<span itemscope=\"\" itemtype=\"http://data-vocabulary.org/Breadcrumb\"><a href=\"/element/1\" itemprop=\"url\"><span itemprop=\"title\">Element 1</span></a></span>",
                     microdata_builder(@template, generate_elements(1), :separator => "-").render)
  end


  def test_render
    @template.expects(:current_page?).times(2).returns(false)
    assert_dom_equal("<span itemscope=\"\" itemtype=\"http://data-vocabulary.org/Breadcrumb\"><a href=\"/element/1\" itemprop=\"url\"><span itemprop=\"title\">Element 1</span></a></span> &raquo; <span itemscope=\"\" itemtype=\"http://data-vocabulary.org/Breadcrumb\"><a href=\"/element/2\" itemprop=\"url\"><span itemprop=\"title\">Element 2</span></a></span>",
                     microdata_builder(@template, generate_elements(2)).render)
  end

  def test_render_with_separator
    @template.expects(:current_page?).times(2).returns(false)
    assert_dom_equal("<span itemscope=\"\" itemtype=\"http://data-vocabulary.org/Breadcrumb\"><a href=\"/element/1\" itemprop=\"url\"><span itemprop=\"title\">Element 1</span></a></span> - <span itemscope=\"\" itemtype=\"http://data-vocabulary.org/Breadcrumb\"><a href=\"/element/2\" itemprop=\"url\"><span itemprop=\"title\">Element 2</span></a></span>",
                     microdata_builder(@template, generate_elements(2), :separator => " - ").render)
  end

  def test_render_with_current_page
    @template.expects(:current_page?).times(2).returns(false, true)
    assert_dom_equal("<span itemscope=\"\" itemtype=\"http://data-vocabulary.org/Breadcrumb\"><a href=\"/element/1\" itemprop=\"url\"><span itemprop=\"title\">Element 1</span></a></span> &raquo; <span itemscope=\"\" itemtype=\"http://data-vocabulary.org/Breadcrumb\"><span itemprop=\"title\">Element 2</span></span>",
                     microdata_builder(@template, generate_elements(2)).render)
  end


  protected

  def microdata_builder(*args)
    BreadcrumbsOnRails::Breadcrumbs::MicrodataBuilder.new(*args)
  end

  def generate_elements(number)
    (1..number).collect do |index|
      BreadcrumbsOnRails::Breadcrumbs::Element.new("Element #{index}", "/element/#{index}")
    end
  end

end
