module BreadcrumbsOnRails
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
end
