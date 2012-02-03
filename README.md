# Breadcrumbs On Rails

*BreadcrumbsOnRails* is a simple Ruby on Rails plugin for creating and managing a breadcrumb navigation for a Rails project.
It provides helpers for creating navigation elements with a flexible interface.


## Requirements

* Rails 3

Please note 

* BreadcrumbsOnRails 2.x requires Rails 3. Use BreadcrumbsOnRails 1.x with Rails 2.
* BreadcrumbsOnRails doesn't work with Rails 2.1 or lower.


## Installation

[RubyGems](http://rubygems.org) is the preferred way to install *BreadcrumbsOnRails* and the best way if you want install a stable version.

    $ gem install breadcrumbs_on_rails

Specify the Gem dependency in the [Bundler](http://gembundler.com) `Gemfile`.

    gem "breadcrumbs_on_rails"

Use [Bundler](http://gembundler.com) and the [:git option](http://gembundler.com/v1.0/git.html) if you want to grab the latest version from the Git repository.


## Basic Usage

Creating a breadcrumb navigation menu in your Rails app using *BreadcrumbsOnRails* is really straightforward.

In your controller, call `add_breadcrumb` to push a new element on the breadcrumb stack. `add_breadcrumb` requires two arguments: the name of the breadcrumb and the target path.

    class MyController
    
      add_breadcrumb "home", :root_path
      add_breadcrumb "my", :my_path
      
      def index
        # ...
        
        add_breadcrumb "index", index_path
      end
    
    end

The third, optional argument is a Hash of options to customize the breadcrumb link.

    class MyController
      def index
        add_breadcrumb "index", index_path, :title => "Back to the Index"
      end
    end

In your view, you can render the breadcrumb menu with the `render_breadcrumbs` helper.

    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
      "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <title>untitled</title>
    </head>
    
    <body>
      <%= render_breadcrumbs %>
    </body>
    </html>

`render_breadcrumbs` understands a limited set of options. For example, you can pass change the default separator with the `:separator` option.

    <body>
      <%= render_breadcrumbs :separator => ' / ' %>
    </body>

More complex customizations require a custom Builder.

Read the [documentation](http://www.simonecarletti.com/code/breadcrumbs_on_rails/docs/) to learn more about advanced usage and builders.


## Credits

* [Simone Carletti](http://www.simonecarletti.com/) <weppos@weppos.net> - The Author


## Resources

* [Homepage](http://www.simonecarletti.com/code/breadcrumbs_on_rails)
* [Documentation](http://www.simonecarletti.com/code/breadcrumbs_on_rails/docs/)
* [API](http://rubydoc.info/gems/breadcrumbs_on_rails)
* [Repository](https://github.com/weppos/breadcrumbs_on_rails)
* [Issue Tracker](http://github.com/weppos/breadcrumbs_on_rails/issues)


## License

*BreadcrumbsOnRails* is Copyright (c) 2009-2012 Simone Carletti. This is Free Software distributed under the MIT license.
