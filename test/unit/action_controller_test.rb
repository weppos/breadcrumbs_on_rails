require 'test_helper'


class ExampleController < ActionController::Base
  include BreadcrumbsOnRails::ActionController

  def self.controller_name; "example"; end
  def self.controller_path; "example"; end

  layout false

  def action_default
    execute("action_default")
  end

  def action_compute_paths
    add_breadcrumb "String", "/"
    add_breadcrumb "Proc", proc { |c| "/?proc" }
    add_breadcrumb "Polymorphic", [:admin, :namespace]
    execute("action_default")
  end


  private

  def execute(method)
    if method.to_s =~ /^action_(.*)/
      render :action => (params[:template] || 'default')
    end
  end

  def admin_namespace_path(*)
    "/?polymorphic"
  end
  helper_method :admin_namespace_path

end

class ExampleControllerTest < ActionController::TestCase
  tests ExampleController

  def test_render_default
    get :action_default
    assert_dom_equal  %(),
                      @response.body
  end

  def test_render_compute_paths
    get :action_compute_paths
    assert_dom_equal  %(<a href="/">String</a> &raquo; <a href="/?proc">Proc</a> &raquo; <a href="/?polymorphic">Polymorphic</a>),
                      @response.body.to_s
  end

end

class ClassLevelExampleController < ActionController::Base
  include BreadcrumbsOnRails::ActionController

  add_breadcrumb "String", "/"
  add_breadcrumb "Proc", proc { |c| "/?proc" }
  add_breadcrumb "Polymorphic", [:admin, :namespace]
  add_breadcrumb "With options", "/", :options => { :title => "Awesome" }

  def action_default
    render 'example/default'
  end

  private

  def admin_namespace_path(*)
    "/?polymorphic"
  end
  helper_method :admin_namespace_path

end

class ClassLevelExampleControllerTest < ActionController::TestCase

  def test_render_default
    expected = [].tap { |links|
      links << '<a href="/">String</a>'
      links << '<a href="/?proc">Proc</a>'
      links << '<a href="/?polymorphic">Polymorphic</a>'
      links << '<a title="Awesome" href="/">With options</a>'
    }

    get :action_default
    assert_dom_equal  expected.join(" &raquo; "), 
                      @response.body.to_s
  end

end

class MultipleExampleController < ActionController::Base
  include BreadcrumbsOnRails::ActionController

  def self.controller_name; "example"; end
  def self.controller_path; "example"; end

  layout false

  def action_default
    add_breadcrumb "String", "/"
    add_breadcrumb "Hoge", "/hoge/"
    add_breadcrumb "Me", "/hoge/moge"

    next_breadcrumbs

    add_breadcrumb "String", "/"
    add_breadcrumb "Moge", "/moge/"
    add_breadcrumb "You", "/hoge/moge"

    execute("action_default")
  end

  def action_compute_paths
    add_breadcrumb "String", "/"
    add_breadcrumb "Proc", proc { |c| "/?proc" }
    add_breadcrumb "Polymorphic", [:admin, :namespace]

    next_breadcrumbs

    add_breadcrumb "String", "/hoge/"
    add_breadcrumb "Proc", proc { |c| "/?proc" }
    add_breadcrumb "xxPolymorphic", [:admin, :namespace]

    execute("action_default")
  end

  private

  def execute(method)
    if method.to_s =~ /^action_(.*)/
      render :action => (params[:template] || 'default')
    end
  end

  def admin_namespace_path(*)
    "/?polymorphic"
  end
  helper_method :admin_namespace_path

end

class MultipleWithIndexExampleController < ActionController::Base
  include BreadcrumbsOnRails::ActionController

  def self.controller_name; "example"; end
  def self.controller_path; "example"; end

  layout false

  def action_default
    add_breadcrumb "String", "/"
    add_breadcrumb "Hoge", "/hoge/"

    next_breadcrumbs

    add_breadcrumb "String", "/"
    add_breadcrumb "Moge", "/moge/"

    add_breadcrumb "Me", "/hoge/moge", { index: 0 }
    add_breadcrumb "You", "/hoge/moge"

    execute("action_default")
  end

  def action_compute_paths
    add_breadcrumb "String", "/"
    add_breadcrumb "Proc", proc { |c| "/?proc" }

    next_breadcrumbs

    add_breadcrumb "String", "/hoge/"
    add_breadcrumb "Proc", proc { |c| "/?proc" }

    add_breadcrumb "Polymorphic", [:admin, :namespace], { index: 0 }
    add_breadcrumb "xxPolymorphic", [:admin, :namespace]

    execute("action_default")
  end

  private

  def execute(method)
    if method.to_s =~ /^action_(.*)/
      render :action => (params[:template] || 'default')
    end
  end

  def admin_namespace_path(*)
    "/?polymorphic"
  end
  helper_method :admin_namespace_path

end

class MultipleExampleControllerTest < ActionController::TestCase
  tests MultipleExampleController

  def test_render_default
    get :action_default
    assert_dom_equal  %(<a href="/">String</a> &raquo; <a href="/hoge/">Hoge</a> &raquo; <a href="/hoge/moge">Me</a>|<a href="/">String</a> &raquo; <a href="/moge/">Moge</a> &raquo; <a href="/hoge/moge">You</a>),
                      @response.body
  end

  def test_render_compute_paths
    get :action_compute_paths
    assert_dom_equal  %(<a href="/">String</a> &raquo; <a href="/?proc">Proc</a> &raquo; <a href="/?polymorphic">Polymorphic</a>|<a href="/hoge/">String</a> &raquo; <a href="/?proc">Proc</a> &raquo; <a href="/?polymorphic">xxPolymorphic</a>),
                      @response.body
  end

end

class MultipleWithIndexExampleControllerTest < ActionController::TestCase
  tests MultipleWithIndexExampleController

  def test_render_default
    get :action_default
    assert_dom_equal  %(<a href="/">String</a> &raquo; <a href="/hoge/">Hoge</a> &raquo; <a href="/hoge/moge">Me</a>|<a href="/">String</a> &raquo; <a href="/moge/">Moge</a> &raquo; <a href="/hoge/moge">You</a>),
                      @response.body
  end

  def test_render_compute_paths
    get :action_compute_paths
    assert_dom_equal  %(<a href="/">String</a> &raquo; <a href="/?proc">Proc</a> &raquo; <a href="/?polymorphic">Polymorphic</a>|<a href="/hoge/">String</a> &raquo; <a href="/?proc">Proc</a> &raquo; <a href="/?polymorphic">xxPolymorphic</a>),
                      @response.body
  end

end

class ExampleHelpersTest < ActionView::TestCase
  tests BreadcrumbsOnRails::ActionController::HelperMethods
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper

  attr_accessor :breadcrumbs_list

  setup do
    self.breadcrumbs_list = [[]]
  end

  def test_render_breadcrumbs
    assert_dom_equal '', render_breadcrumbs
  end

end

