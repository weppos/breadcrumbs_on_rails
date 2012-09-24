require 'test_helper'

BreadcrumbsOnRails.configure do |config|
  config.add_breadcrumb :static_breadcrumb, :root_path
  config.add_breadcrumb :static_breadcrumb_bis, :root_path, :breadcrumb => :default

  config.definer :user_menu, :flag_for_breadcrumb => true do |d|
    d.add_breadcrumb :home, :root_path
    d.add_breadcrumb :users, :users_path, :flag => :users do |breadcrumb|
      breadcrumb.add_breadcrumb :dashboard, :dashboard_users_path
      breadcrumb.add_breadcrumb :help, :help_users_path
    end
    
    d.set_flag :home, true
    d.set_flag :users, false
  end

end


class BreadcrumbsTestController < ActionController::Base
  add_breadcrumb :root, :extranet_root_path
  add_breadcrumb :footab, :root_path
  add_breadcrumb_for_current :current_page 

  set_flag :foo, true
  set_flag :bar, false

  definer :user_menu, :flag_for_breadcrumb => true do |d|
    d.add_breadcrumb :dashboard, :root_path
    d.add_breadcrumb :main_screen, :root_path

    d.set_flag :dashboard, false
    d.set_flag :dashboard_icon, :none
    d.set_flag :main_screen_value, 2
  end


  def index
    render :text => ''
  end

  def show
    set_flag :bar, true
    render :text => ''
  end
end

class BreadcrumbsTest < ActionController::TestCase
  tests BreadcrumbsTestController

  def test_add_volatile_breadcrumb
    get :index
    assert_equal(:root, controller.volatile_breadcrumbs(:default).first.name)
  end

  def test_add_breadcrumb_for_current
    get :show
    assert_equal('/breadcrumbs_test/show', controller.volatile_breadcrumbs(:default).last.path)
  end

  def test_add_static_breadcrumb
    get :index
    assert_equal(:static_breadcrumb, controller.breadcrumbs(:default).first.name)
  end

  def test_static_and_volatile_breadcrumbs
    get :index
    assert_equal(5, controller.breadcrumbs(:default).count)
  end

  def test_set_volatile_flag
    get :index
    assert_equal(true, controller.flags(:default)[:foo])
  end

  def test_set_static_flag
    get :index
    assert_equal(true, controller.flags(:user_menu)[:home])
  end

  def test_static_and_volatile_flags
    get :index
    assert_equal(5, controller.flags(:user_menu).count)
  end

  def test_set_flag_within_method
    get :show
    assert_equal(true, controller.flags(:default)[:bar])
  end

  def test_add_breadcrumb_with_definer
    get :index
    assert_equal(:main_screen, controller.breadcrumbs(:user_menu).last.name)
  end

  def test_definer_with_flag_for_breadcrumb_set
    get :index
    assert_equal(:main_screen, controller.breadcrumbs(:user_menu).last.options[:flag])
  end

  def test_set_flag_with_definer
    get :index
    assert_equal(:none, controller.flags(:user_menu)[:dashboard_icon])
  end

end

