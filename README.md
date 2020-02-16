# Breadcrumbs On Rails

<tt>BreadcrumbsOnRails</tt> is a simple Ruby on Rails plugin for creating and managing a breadcrumb navigation for a Rails project. It provides helpers for creating navigation elements with a flexible interface.

[![Build Status](https://travis-ci.com/weppos/breadcrumbs_on_rails.svg?branch=master)](https://travis-ci.com/weppos/breadcrumbs_on_rails)
[![Tidelift dependencies](https://tidelift.com/badges/package/rubygems/breadcrumbs_on_rails)](https://tidelift.com/subscription/pkg/rubygems-breadcrumbs.on.rails?utm_source=rubygems-breadcrumbs-on-rails&utm_medium=referral&utm_campaign=enterprise)


## Links

- [Homepage](https://simonecarletti.com/code/breadcrumbs-on-rails)
- [Repository](https://github.com/weppos/breadcrumbs_on_rails)
- [API Documentation](https://rubydoc.info/gems/breadcrumbs_on_rails)


## Requirements

- Ruby >= 2.4
- Rails >= 5

For older versions use a previous release.


## Installation

Add this line to your application's `Gemfile`:

```
gem "breadcrumbs_on_rails"
```

And then execute `bundle` to install the dependencies:

```
bundle
```

Use [Bundler](http://bundler.io/) and the `:git` option if you want to grab the latest version from the Git repository.


## Usage

Creating a breadcrumb navigation menu in your Rails app using <tt>BreadcrumbsOnRails</tt> is really straightforward.

In your controller, call `add_breadcrumb` to push a new element on the breadcrumb stack. `add_breadcrumb` requires two arguments: the name of the breadcrumb and the target path.

```ruby
class MyController

  add_breadcrumb "home", :root_path
  add_breadcrumb "my", :my_path

  def index
    # ...

    add_breadcrumb "index", index_path
  end

end
```

See the section "Breadcrumb Element" for more details about name and target class types.

The third, optional argument is a Hash of options to customize the breadcrumb link.

```ruby
class MyController
  def index
    add_breadcrumb "index", index_path, title: "Back to the Index"
  end
end
```

In your view, you can render the breadcrumb menu with the `render_breadcrumbs` helper.

```html
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
```

`render_breadcrumbs` understands a limited set of options. For example, you can pass change the default separator with the `:separator` option.

```html
<body>
  <%= render_breadcrumbs :separator => ' / ' %>
</body>
```

Current possible options are:

- `:separator`
- `:tag`

To use with Bootstrap you might use the following:

```html
<body>
  <ol class="breadcrumb">
    <%= render_breadcrumbs :tag => :li, :separator => "" %>
  </ol>
</body>
```

More complex customizations require a custom `Builder`.

### HTML Escaping

The text of the breadcrumb is html-escaped by default unless it is a SafeBuffer, to prevent XSS attacks.

```ruby
class MyController
  add_breadcrumb "This is the <b>Main</b> page".html_safe

  def profile
    add_breadcrumb "#{@user_name} Profile", users_profile
  end
end
```

In this case, if `@user_name` is `<script>`, it will output:

```
This is the <b>Main</b> page > &lt;script&gt; Profile
```


### Breadcrumb Element

A breadcrumbs menu is composed by a number of `Element` objects. Each object contains two attributes: the name of the breadcrumb and the target path.

When you call `add_breadcrumb`, the method automatically creates a new `Element` object for you and append it to the breadcrumbs stack. `Element` name and path can be one of the following Ruby types:

- `Symbol`
- `Proc`
- `String`

#### Symbol

If the value is a `Symbol`, the library calls the corresponding method defined in the same context the and sets the `Element` attribute to the returned value.

```ruby
class MyController
  
  # The Name is set to the value returned by
  # the :root_name method.
  add_breadcrumb :root_name, "/"
  
  protected
  
    def root_name
      "the name"
    end
  
end
```

#### Proc

If the value is a `Proc`, the library calls the proc passing the current view context as argument and sets the `Element` attribute to the returned value. This is useful if you want to postpone the execution to get access to some special methods/variables created in your controller action.

```ruby
class MyController

  # The Name is set to the value returned by
  # the :root_name method.
  add_breadcrumb Proc.new { |c| c.my_helper_method },
                 "/"

end
```

#### String

If the value is a `String`, the library sets the `Element` attribute to the string value.

```ruby
class MyController

  # The Name is set to the value returned by
  # the :root_name method.
  add_breadcrumb "homepage", "/"

end
```

### Restricting breadcrumb scope

The `add_breadcrumb` method understands all options you are used to pass to a Rails controller filter. In fact, behind the scenes this method uses a `before_filter` to store the tab in the `@breadcrumbs` variable.

Taking advantage of Rails filter options, you can restrict a tab to a selected group of actions in the same controller.

```ruby
class PostsController < ApplicationController
  add_breadcrumb "admin", :admin_path
  add_breadcrumb "posts", :posts_path, only: [:index, :show]
end

class ApplicationController < ActionController::Base
  add_breadcrumb "admin", :admin_path, if: :admin_controller?
  
  def admin_controller?
    self.class.name =~ /^Admin(::|Controller)/
  end
end
```

### Internationalization and Localization

<tt>BreadcrumbsOnRails</tt> is compatible with the standard Rails internationalization framework.

For example, if you want to localize your menu, define a new breadcrumbs node in your `.yml` file with all the keys for your elements.

```yaml
# config/locales/en.yml
en:
  breadcrumbs:
    homepage: Homepage
    first: First
    second: Second
    third: Third

# config/locales/it.yml
it:
  breadcrumbs:
    homepage: Homepage
    first: Primo
    second: Secondo
    third: Terzo
```

In your controller, use the `I18n.t` method.

```ruby
class PostsController < ApplicationController
  add_breadcrumb I18n.t("breadcrumbs.first"),  :first_path
  add_breadcrumb I18n.t("breadcrumbs.second"), :second_path, only: [:second]
  add_breadcrumb I18n.t("breadcrumbs.third"),  :third_path,  only: [:third]
end

class ApplicationController < ActionController::Base
  add_breadcrumb I18n.t("breadcrumbs.homepage"), :root_path
end
```


## Support

Library documentation is auto-generated from the [README](https://github.com/weppos/breadcrumbs_on_rails/blob/master/README.md) and the source code, and it's available at https://rubydoc.info/gems/breadcrumbs_on_rails.

- The bug tracker is here: https://github.com/weppos/breadcrumbs_on_rails/issues
- The code repository is here: https://github.com/weppos/breadcrumbs_on_rails. Contributions are welcome! Please include tests and/or feature coverage for every patch, and create a topic branch for every separate change you make.

**Commercial support available as part of the Tidelift Subscription** - [Learn more](https://tidelift.com/subscription/pkg/rubygems-breadcrumbs.on.rails?utm_source=rubygems-breadcrumbs-on-rails&utm_medium=referral&utm_campaign=enterprise&utm_term=repo)

The maintainers of breadcrumbs_on_rails and thousands of other packages are working with Tidelift to deliver commercial support and maintenance for the open source dependencies you use to build your applications. Save time, reduce risk, and improve code health, while paying the maintainers of the exact dependencies you use. [Consider subscribing to Tidelift which provides Enterprise support for this project.](https://tidelift.com/subscription/pkg/rubygems-breadcrumbs.on.rails?utm_source=rubygems-breadcrumbs-on-rails&utm_medium=referral&utm_campaign=enterprise&utm_term=repo)


## Credits

<tt>BreadcrumbsOnRails</tt> was created and is maintained by [Simone Carletti](http://simonecarletti.com/). Many improvements and bugfixes were contributed by the [open source community](https://github.com/weppos/breadcrumbs_on_rails/graphs/contributors).


## Security and Vulnerability Reporting

Full information and description of our security policy please visit [SECURITY.md](SECURITY.md)


## Changelog

See the [CHANGELOG.md](CHANGELOG.md) file for details.


## License

Copyright (c) 2009-2020 Simone Carletti. This is Free Software distributed under the MIT license.
