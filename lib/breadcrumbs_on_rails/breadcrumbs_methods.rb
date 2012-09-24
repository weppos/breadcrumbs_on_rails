module BreadcrumbsOnRails
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

  # breadcrumbs
  def self.add_breadcrumb(name, path, options = {}, &block)
    breadcrumb = options[:breadcrumb]
    add_breadcrumb_to(static_breadcrumbs(breadcrumb), name, path, options, &block)
  end

  # return static breadcrumbs
  def self.static_breadcrumbs(breadcrumb = nil)
    breadcrumb = :default if breadcrumb.nil? 
    @breadcrumbs ||= {}
    @breadcrumbs[breadcrumb] ||= []
  end
end

