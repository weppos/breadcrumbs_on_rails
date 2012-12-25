ENV["RAILS_ENV"] = "test"

require "active_support"
require "action_controller"
require "rails/railtie"


class Dummy
  Routes = ActionDispatch::Routing::RouteSet.new
  Routes.draw do
    match ':controller(/:action(/:id))'
  end
end

ActionController::Base.view_paths = File.join(File.dirname(__FILE__), 'views')
ActionController::Base.send :include, Dummy::Routes.url_helpers

class ActiveSupport::TestCase

  setup do
    @routes = Dummy::Routes
  end


  def controller
    @controller_proxy ||= ControllerProxy.new(@controller)
  end

  class ControllerProxy
    def initialize(controller)
      @controller = controller
    end
    def method_missing(method, *args)
      @controller.instance_eval do
        m = method(method)
        m.call(*args)
      end
    end
  end

end
