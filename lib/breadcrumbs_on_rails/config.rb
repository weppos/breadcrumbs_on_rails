require 'active_support/configurable'

module BreadcrumbsOnRails
  # Configures global settings for BreadcrumbsOnRails
  def self.configure(&block)
    yield @config ||= BreadcrumbsOnRails::Configuration.new
  end

  # Global settings for BreadcrumbsOnRails
  def self.config
    @config
  end

  def self.add_breadcrumb(name, path, options = {}, &block)
    breadcrumb = options[:breadcrumb]
    add_breadcrumb_to(static_breadcrumbs(breadcrumb), name, path, options = {}, &block)
  end

  def self.add_breadcrumb_to(breadcrumb, name, path, options = {}, &block)
    #self.breadcrumbs << Breadcrumbs::Element.new(name, path)
    elem = Breadcrumbs::Element.new(name, path)

    yield elem if block_given?
    breadcrumb << elem
  end

  def self.static_breadcrumbs(breadcrumb = nil)
    breadcrumb = :default if breadcrumb.nil? 
    @breadcrumbs ||= {}
    @breadcrumbs[breadcrumb] ||= []
  end

  # need a Class for 3.0
  class Configuration #:nodoc:
    include ActiveSupport::Configurable
    config_accessor :breadcrumbs

    def define_static_breadcrumb(breadcrumb, name, path = nil, options = {}, &block)
      options[:breadcrumb] = breadcrumb
      add_static_breadcrumb(name, path, options, &block)
    end

    def add_static_breadcrumb(name, path = nil, options = {}, &block)
      breadcrumb = BreadcrumbsOnRails.static_breadcrumbs(options[:breadcrumb])
      BreadcrumbsOnRails.add_breadcrumb_to(breadcrumb, name, path, options, &block)
    end
  end
end
