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

  # flags
  def self.static_flags(flagset = nil)
    flagset = :default if flagset.nil? 
    @flags ||= {}
    @flags[flagset] ||= {}
  end

  # add a new flag to a set of flags
  def self.set_flag_in(flags, name, value, options = {})
    flags.merge!({ name => value }) unless name.nil? || value.nil?
  end

  # breadcrumbs
  def self.add_breadcrumb(name, path, options = {}, &block)
    breadcrumb = options[:breadcrumb]
    add_breadcrumb_to(static_breadcrumbs(breadcrumb), name, path, options, &block)
  end

  # create a new breadcrumb element
  def self.new_breadcrumbs_element(name, path = nil, options = {}, &block)
    elem = Breadcrumbs::Element.new(name, path, options)
    yield elem if block_given?
    return elem
  end

  # add a new breadcrumb element to a set of breadcrumbs
  def self.add_breadcrumb_to(breadcrumb, name, path, options = {}, &block)
    breadcrumb << new_breadcrumbs_element(name, path, options, &block)
  end

  # return static breadcrumbs
  def self.static_breadcrumbs(breadcrumb = nil)
    breadcrumb = :default if breadcrumb.nil? 
    @breadcrumbs ||= {}
    @breadcrumbs[breadcrumb] ||= []
  end

  # A breadcrumb definer to create breadcrumbs in a block
  class BreadcrumbsDefiner
    def initialize(breadcrumb, flags, options = {})
      @breadcrumb = breadcrumb
      @flags = flags
      @options = options
    end

    # create a new flag in a block
    def set_flag(name, value = nil, options = {})
      BreadcrumbsOnRails.set_flag_in(@flags, name, value, options)
    end

    # create a new breadcrumbs in a block
    def add_breadcrumb(name, path = nil, options = {}, &block)
      options[:flag] = name if @options[:flag_for_breadcrumb] == true && name.is_a?(Symbol)
      BreadcrumbsOnRails.add_breadcrumb_to(@breadcrumb, name, path, options, &block)
    end
  end

  # need a Class for 3.0
  class Configuration #:nodoc:
    include ActiveSupport::Configurable
    config_accessor :breadcrumbs
    config_accessor :flags

    # common
    def definer(name = nil, options = {}, &block)
      # breadcrumbs
      breadcrumb = BreadcrumbsOnRails.static_breadcrumbs(name)
      # flags
      flags = BreadcrumbsOnRails.static_flags(name)

      # use a definer to allow block
      d = BreadcrumbsDefiner.new(breadcrumb, flags, options)
      yield d if block_given?
    end

    # create a new static flag in the configuration
    def set_flag(name, value = nil, options = {})
      flags = BreadcrumbsOnRails.static_flags(options[:flagset])
      BreadcrumbsOnRails.set_flag_in(flags, name, value, options)
    end

    # create a new static breadcrumbs in the configuration
    def add_breadcrumb(name, path = nil, options = {}, &block)
      breadcrumb = BreadcrumbsOnRails.static_breadcrumbs(options[:breadcrumb])
      BreadcrumbsOnRails.add_breadcrumb_to(breadcrumb, name, path, options, &block)
    end
  end
end
