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

Creating a navigation menu in your Rails app using *BreadcrumbsOnRails* is really straightforward.
There are two kinds of breadcrumbs types, statics and volatiles. The first are kept whereas the second ones are only defined in controllers.
Aside to the menu, you may want to set flags to interact with you menu generator.

To define static menus, do it only once by creating an initializer, there will be availlable everywhere in your controllers.

    # config/initializers/breadcrumbs_config.rb
    BreadcrumbsOnRails.configure do |config|
      # define a breadcrumb (by default, the :default breadcrumb is used)
      config.add_breadcrumb :welcome, :root_path #, :breadcrumb => :default
    
      # define a breadcrumb
      config.add_breadcrumb :home, :root_path, :breadcrumb => :bottomMenu
    
      # definer takes as argument the symbol name of the breadcrumb/flags to use
      config.definer :mainMenu do |d|
        # add_breadcrumb method here takes the sames arguments as in a controller (see below)
        d.add_breadcrumb :home, :root_path
        d.add_breadcrumb :account, :root_path
        d.add_breadcrumb :bien, :root_path
      end
    
      # definer have an optional argument to pass options.
      # The main option is ':flag_for_breadcrumb'.
      # Turn it to 'true' and your definer will associate a flag of the same name for each breadcrumb
      # created. The flag is an option set in the breadcrumb element, and is later accessible in the
      # builder, use it at your own convenience.
      #
      config.definer :mainMenu, :flag_for_breadcrumb => true do |d|
        # add_breadcrumb method here takes the sames arguments as in a controller (see below)
        d.add_breadcrumb :home, :root_path
        d.add_breadcrumb :account, :root_path
        d.add_breadcrumb :bien, :root_path
    
        # flags attributes can be set here
        d.set_flag :home, true
        d.set_flag :bien, false
    
        # you can use as may flag as you need.
        # theses options are accessible in your builders (see below)
        d.add_breadcrumb :visits, :users_path, :right_icon => :visits_icon_flag
    
        # and flag can be set with any value, boolean, or symbols for example
        d.set_flag :visits_icon_flag, :waiting
      end
    
    end


In your controller, call `add_breadcrumb` to push a new element on the breadcrumb stack. <tt>add_breadcrumb</tt> requires two arguments: the name of the breadcrumb and the target path. See the section "Breadcrumb Element" for more details about name and target class types.
The third, optional argument is a Hash of options to customize the breadcrumb.

You can use the same definer as in the configuration, by calling `definer`, except that it will create a volatile block by default.
During the rendering, volatile breadcrumbs/flags will merge with statics ones or override them if they have the same name.
Doing that, you can define default flags in the configuration, and change their values in the controllers.

  class MyController
  
    add_breadcrumb "home", :root_path
    add_breadcrumb "my", :my_path

    # you may specify the breadcrumbs you want to use instead of the default one
    add_breadcrumb "my", :my_path, :breadcrumb => :bottomMenu
    
    # to add sub-menu (alternate breadcrumbs for the same level)
    add_breadcrumb :users, :users_path do |bread|
      # add submenu using a symbol for translation (see translation below)
      bread.add_child :accounts, :accounts_path
      # or a string
      bread.add_child "Profiles", :profiles_path
    end

    # to add a breadcrumb for current view
    add_breadcrumb_for_current "My profile"

    # definer takes as argument the symbol name of the breadcrumb/flags to use
    definer :mainMenu do |d|
      d.add_breadcrumb :home, :root_path
      d.add_breadcrumb :bien, :root_path
    end

    # definer in the controller takes the same optional argument as in the configuration, to pass options.
    definer :mainMenu, :flag_for_breadcrumb => true do |d|
      d.add_breadcrumb :folder, :folders_path

      # volatile flags override statics ones
      d.set_flag :visits_icon_flag, :valid
    end


    def index
      # ...
      
      add_breadcrumb "index", index_path
    end

    def create
      # definer in the controller takes the same optional argument as in the configuration, to pass options.
      # By default, volatile blocks are defined in the controller. You may use the <tt>static</tt> option to create static block.
      definer :mainMenu, :flag_for_breadcrumb => true, :static => true do |d|
        d.add_breadcrumb :account, :account_path

        # flags attributes can be set here
        d.set_flag :home, true
        d.set_flag :bien, false

        # you can use as may flag as you need.
        # theses options are accessible in your builders (see below)
        d.add_breadcrumb :cart, :cart_path, :right_icon => :cart_icon_flag

        # and flag can be set with any value, boolean, or symbols for example
        d.set_flag :cart_icon_flag, :waiting
      end
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

`render_breadcrumbs` understands a limited set of options. For example, you can pass change the default separator with the `:separator` option, or the default breadcrumb to use with the `:breadcrumb` option.

    <body>
      <%= render_breadcrumbs :separator => ' / ', :breadcrumb => :side_menu_breadcrumb %>
    </body>

More complex customizations require a custom Builder, see custom builder below or read the [documentation](http://www.simonecarletti.com/code/breadcrumbs_on_rails/docs/) to learn more about advanced usage and builders.

### Breadcrumb Element

A breadcrumbs menu is composed by a number of `Element` objects. Each object contains two attributes: the name of the breadcrumb and the target path.

When you call `add_breadcrumb`, the method automatically creates a new `Element` object for you and append it to the breadcrumbs stack. `Element` name and path can be one of the following Ruby types:

* Symbol
* Proc
* String

#### Symbol

If the value is a Symbol, it can be used for two different things.
At first, the library try to call the corresponding method in the same context and sets the `Element` attribute to the returned value.
Then, if no method are found with that name, the library search for a key in the translation. (see below for translation keys examples)

    class MyController
    
      # The Name is set to the value returned by
      # the :root_name method.
      add_breadcrumb :function_name, "/"
      add_breadcrumb :translate_me, "/"
      
      protected
  
        def function_name
          "the name"
        end
    
    end

#### Proc

If the value is a Proc, the library calls the proc passing the current view context as argument and sets the `Element` attribute to the returned value. This is useful if you want to postpone the execution to get access to some special methods/variables created in your controller action.

    class MyController
    
      # The Name is set to the value returned by
      # the :root_name method.
      add_breadcrumb Proc.new { |c| c.my_helper_method },
                     "/"
      
    end

#### String

If the value is a String, the library sets the `Element` attribute to the string value.

    class MyController
      
      # The Name is set to the value returned by
      # the :root_name method.
      add_breadcrumb "homepage", "/"
    
    end


### Restricting breadcrumb scope

The `add_breadcrumb` method understands all options you are used to pass to a Rails controller filter.
In fact, behind the scenes this method uses a `before_filter` to store the tab in the `@breadcrumbs` variable.

Taking advantage of Rails filter options, you can restrict a tab to a selected group of actions in the same controller.

    class PostsController < ApplicationController
      add_breadcrumb "admin", :admin_path
      add_breadcrumb "posts", :posts_path, :only => %w(index show)
    end
    
    class ApplicationController < ActionController::Base
      add_breadcrumb "admin", :admin_path, :if => :admin_controller?
      
      def admin_controller?
        self.class.name =~ /^Admin(::|Controller)/
      end
    end

### Internationalization and Localization

BreadcrumbsOnRails is compatible with the standard Rails internationalization framework. 

For our previous example, if you want to localize your menu, define a new breadcrumbs node in your .yml file with all the keys for your elements.
The convention is 'breadcrumbs.menus' followed by your breadcrumbs symbol (:default by default) then by the menu hierachy.

    add_breadcrumb :users, :users_path do |bread|
      # add submenu using a symbol for translation (see translation below)
      bread.add_child :accounts, :accounts_path 
    end

The menu itself is translated here by 'breadcrumbs.menus.default.users.root', and the sub-menu is 'breadcrumbs.menus.default.users.accounts'.

    # config/locales/en.yml
    en:
      breadcrumbs:
        menus:
          default:
            translate_me: "Translated"
            users:
              root: "Menu title"
              accounts: "Accounts sub menu"
      events:
        new_year: "Happy new year"
    
    # config/locales/it.yml
    it:
      breadcrumbs:
        menus:
          default:
            translate_me: "Traduto"
            users:
              root: "Tittoro del menu"
              accounts: "Sotto-menu dei conti"
      events:
        new_year: "Felice anno nuovo"
    
    # config/locales/fr.yml
    fr:
      breadcrumbs:
        menus:
          default:
            translate_me: "Traduit"
            users:
              root: "Titre du menu"
              accounts: "Sous-menu des comptes"
      events:
        new_year: "Bonne annee"

In your controller, you can also use the `I18n.t` method directly as it returns a string.

    class PostsController < ApplicationController
      add_breadcrumb I18n.t("events.new_year"),  :events_path
      add_breadcrumb I18n.t("events.holidays"),  :events_path, :only => %w(holidays)
    end
    
    class ApplicationController < ActionController::Base
      add_breadcrumb I18n.t("breadcrumbs.homepage"), :root_path
    end

### Custom builder

If you need a more complex breadcrumb, or a menu, you'll need to define a custom builder.
To create such builder, add a file like the following.
In your builder, you can use `flag_for(element, [:name_of_the_flag])`, without its optional argument you'll get the flag named ':flag'

    # /lib/breadcrumbs_on_rails/breadcrumbs/html_builder.rb
    module BreadcrumbsOnRails
      module Breadcrumbs
        # The HtmlBuilder is an html5 breadcrumb builder.
        # It provides a simple way to render breadcrumb navigation as html5 tags.
        #
        # To use this custom Builder pass the option :builder => BuilderClass to the <tt>render_breadcrumbs</tt> helper method.
        #
        class HtmlBuilder < Builder
    
          def render
            # creating nav id=breadcrumb
            @context.content_tag(:nav, :id => 'breadcrumb') do
              render_elements(@elements)
            end
          end
    
          def render_elements(elements)
            content = nil
            elements.each do |element|
              if content.nil?
                content = render_element(element)
              else
                content << render_element(element)
              end
            end
            @context.content_tag(:ul, content)
          end
    
          def render_element(element)
            # getting optionnal css class attributes
            right_icon_class = element.options[:right_icon_class]
            if right_icon_class.nil?
              right_icon_class = case flag_for(element, :right_icon) # we specify the name of the flag we want to read
              when :valid
                "i01"
              when :waiting
                "i02"
              else
                ""
              end
            end
    
            # preparing element
            if (element.childs.length > 0)
              content = @context.link_to(compute_path(element)) do
                @context.content_tag(:span, compute_name(element)), :class => right_icon_class)
              end
            else
              content = @context.link_to(compute_name(element), compute_path(element))
            end
    
            # rendering sub-elements
            if element.childs.length > 0
              content = content + render_elements(element.childs)
            end
    
            # adding element and it's sub-elements
            klass = (flag_for(element) == true ? 'activ' : '') # by default, flag_for returns the flag named ':flag'
            @context.content_tag(:li, content) #, :class => klass)
          end
        end
      end
    end


And do not forget to add /lib to rails autoload_paths by adding the following line.

    # config/application.rb
    module MyNiceRailsApplication
      class Application < Rails::Application
    
        ...

        # Custom directories with classes and modules you want to be autoloadable.
        # config.autoload_paths += %W(#{config.root}/extras)
        config.autoload_paths += %W( #{config.root}/lib )
    
        ...
    
      end
    end

Use your new builder by adding the builder option to the renderer.

    <%= render_breadcrumbs(:builder => BreadcrumbsOnRails::Breadcrumbs::HtmlBuilder) %>

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
