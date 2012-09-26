require 'test_helper'

class ElementTest < ActiveSupport::TestCase

  def test_initialize_should_require_name
    assert_raise(ArgumentError) { BreadcrumbsOnRails::Breadcrumbs::Element.new }
    assert_nothing_raised { BreadcrumbsOnRails::Breadcrumbs::Element.new(nil) }
  end

  def test_initialize_should_set_name
    element = BreadcrumbsOnRails::Breadcrumbs::Element.new(:homepage, nil)
    assert_equal :homepage, element.name
  end

  def test_initialize_should_set_path
    element = BreadcrumbsOnRails::Breadcrumbs::Element.new(nil, "/")
    assert_equal "/", element.path
  end

  def test_initialize_should_allow_options
    element = BreadcrumbsOnRails::Breadcrumbs::Element.new(:homepage, "/", :title => "Go to the Homepage")
    assert_equal({ :title => "Go to the Homepage" }, element.options)
  end


  def test_name
    element = BreadcrumbsOnRails::Breadcrumbs::Element.new(nil, nil)
    element.name = :the_name
    assert_equal :the_name, element.name
  end

  def test_path
    element = BreadcrumbsOnRails::Breadcrumbs::Element.new(nil, nil)
    element.path = { :controller => "index", :action => "index" }
    assert_equal({ :controller => "index", :action => "index" }, element.path)
  end

  def test_options
    element = BreadcrumbsOnRails::Breadcrumbs::Element.new(nil, nil)
    element.options = { :title => "Go to the Homepage" }
    assert_equal({ :title => "Go to the Homepage" }, element.options)
  end
  
  def test_path_is_optional
    element = BreadcrumbsOnRails::Breadcrumbs::Element.new(:homepage)
    assert_nil element.path
  end

end
