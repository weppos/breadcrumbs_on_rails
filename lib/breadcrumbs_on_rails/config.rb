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
