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

  def self.new_breadcrumbs_element(name, path = nil, options = {}, &block)
    elem = Breadcrumbs::Element.new(name, path, options)
    yield elem if block_given?
    return elem
  end

  def self.add_breadcrumb_to(breadcrumb, name, path, options = {}, &block)
    breadcrumb << new_breadcrumbs_element(name, path, options, &block)
  end

  def self.static_breadcrumbs(breadcrumb = nil)
    breadcrumb = :default if breadcrumb.nil? 
    @breadcrumbs ||= {}
    @breadcrumbs[breadcrumb] ||= []
  end

  # A breadcrumb definer to create breadcrumbs in a block
  class BreadcrumbsDefiner
    def initialize(breadcrumb)
      @breadcrumb = breadcrumb
    end

    def add_breadcrumb(name, path = nil, options = {}, &block)
      @breadcrumb << BreadcrumbsOnRails.new_breadcrumbs_element(name, path, options, &block)
    end
  end

  # need a Class for 3.0
  class Configuration #:nodoc:
    include ActiveSupport::Configurable
    config_accessor :breadcrumbs

    #def define_static_breadcrumb(breadcrumb, name, path = nil, options = {}, &block)
    #  options[:breadcrumb] = breadcrumb
    #  add_static_breadcrumb(name, path, options, &block)
    #end

    def define_static_breadcrumb(breadcrumb = nil, &block)
      #options[:breadcrumb] = breadcrumb
      breadcrumb = BreadcrumbsOnRails.static_breadcrumbs(breadcrumb)
      definer = BreadcrumbsDefiner.new(breadcrumb)
      #yield breadcrumb if block_given?
      yield definer if block_given?
    end

    def add_static_breadcrumb(name, path = nil, options = {}, &block)
      breadcrumb = BreadcrumbsOnRails.static_breadcrumbs(options[:breadcrumb])
      BreadcrumbsOnRails.add_breadcrumb_to(breadcrumb, name, path, options, &block)
    end
    
    #def add_breadcrumb(name, path = nil, options = {}, &block)
    #  BreadcrumbsOnRails.new_breadcrumbs_element(name, path, options, &block)
    #end
  end
end
