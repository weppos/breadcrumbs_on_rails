# Breadcrumbs On Rails
[![Code Climate](https://codeclimate.com/github/weppos/breadcrumbs_on_rails.png)](https://codeclimate.com/github/weppos/breadcrumbs_on_rails)

<tt>BreadcrumbsOnRails</tt> is a simple Ruby on Rails plugin for creating and managing a breadcrumb navigation for a Rails project. It provides helpers for creating navigation elements with a flexible interface.


## Requirements

- Rails 3 or Rails 4

Please note 

- <tt>BreadcrumbsOnRails</tt> 2.x requires Rails 3. Use <tt>BreadcrumbsOnRails</tt> 1.x with Rails 2.
- <tt>BreadcrumbsOnRails</tt> doesn't work with Rails 2.1 or lower.


## Installation

[RubyGems](http://rubygems.org) is the preferred way to install <tt>BreadcrumbsOnRails</tt> and the best way if you want install a stable version.

    $ gem install breadcrumbs_on_rails

Specify the Gem dependency in the [Bundler](http://bundler.io/) `Gemfile`.

    gem "breadcrumbs_on_rails"

Use [Bundler](http://bundler.io/) and the `:git` option if you want to grab the latest version from the Git repository.


## Basic Usage

Creating a breadcrumb navigation menu in your Rails app using <tt>BreadcrumbsOnRails</tt> is really straightforward.

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
      add_breadcrumb "home", :root_path, :options => { :title => "Home" }

      def index
        add_breadcrumb "index", index_path, :title => "Back to the Index"
      end
    end

In your view, you can render the breadcrumb menu with the `render_breadcrumbs` helper.

    <!DOCTYPE html>
    <html>
    <head>
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

Current possible options are:
- `:separator`
- `:tag`

To use with Bootstrap you might use the following:

    <body>
      <ol class="breadcrumb">
        <%= render_breadcrumbs :tag => :li, :separator => "" %>
      </ol>
    </body>

More complex customizations require a custom Builder.

Read the [documentation](http://simonecarletti.com/code/breadcrumbs_on_rails/docs/) to learn more about advanced usage and builders.


## Credits

<tt>BreadcrumbsOnRails</tt> was created and is maintained by [Simone Carletti](http://simonecarletti.com/). Many improvements and bugfixes were contributed by the [open source community](https://github.com/weppos/whois/graphs/contributors).


## Contributing

Direct questions and discussions to [Stack Overflow](http://stackoverflow.com/questions/tagged/breadcrumbs-on-rails).

[Pull requests](https://github.com/weppos/whois/breadcrumbs_on_rails) are very welcome! Please include tests for every patch, and create a topic branch for every separate change you make.

Report issues or feature requests to [GitHub Issues](https://github.com/weppos/breadcrumbs_on_rails/issues).


## More Information

- [Homepage](http://simonecarletti.com/code/breadcrumbs_on_rails)
- [RubyGems](http://rubygems.org/gems/breadcrumbs_on_rails)
- [Documentation](http://simonecarletti.com/code/breadcrumbs_on_rails/docs/)
- [Issues](https://github.com/weppos/breadcrumbs_on_rails/issues)


## License

<tt>BreadcrumbsOnRails</tt> is Copyright (c) 2009-2014 Simone Carletti. This is Free Software distributed under the MIT license.
