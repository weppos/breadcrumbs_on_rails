# Changelog

## Release 4.1.0

### Changed

- Swapped dependency on "rails" to "railties" (GH-135)

## Release 4.0.0

### Changed

- Minimum requirements Rails >= 5

### Enhancements

- Prefixed shared helpers to reduce collision probability (GH-65, GH-129). [Thanks @justame, @ngelx]


## Release 3.0.1

### Fixed

- Fixed compatibility with Rails 5.0 and ActionController::API (GH-99). [Thanks @jcoyne]


## Release 3.0.0

### Fixed

- Fixed compatibility with Rails 5.0 (GH-80). [Thanks @ochko]
- Fixed initialization error (GH-75). [Thanks @soulcutter]
- Escape user input by default to avoid XSS attacks (GH-63). [Thanks @rdunlop]

### Changed

- Minimum requirements Rails >= 4 and Ruby >= 2.


## Release 2.3.1

- FIXED: Using `add_breadcrumbs` did not properly pass `options` (GH-46). [Thanks @link664]


## Release 2.3.0

- FIXED: In some circumstances the BreadcrumbsOnRails::ActionController::HelperMethods is not mixed into the controller.
- FIXED: Breadcrumbs now accepts a polymorphic path (GH-15).

- CHANGED: Second argument on `add_breadcrumb` is now optional (GH-6, GH-32). [Thanks @mpartel]
- CHANGED: Breadcrumb path computation fallbacks to url_for in case of unknown arguments.


## Release 2.2.0

- NEW: Support for Rails 3.2.

- FIXED: Fixed Rails 3.2 ActiveSupport::Concern deprecation warning (GH-17, GH-20).


## Release 2.1.0

- NEW: Element now accepts a Hash of options. The options can be useful to customize the appearance of the element, for example to set a link title or class.


## Release 2.0.0

- FIXED: Invalid documentation for Element target in the controller class context (closes #2)

- CHANGED: Upgraded to Rails 3


## Release 1.0.1

- FIXED: Since the removal of rails/init.rb in 7278376ab77651e540e39552384ad9677e32ff7e, Rails fails to load the helpers.


## Release 1.0.0

- CHANGED: Removed empty install/uninstall hooks and tasks folder.
- CHANGED: Removed rails/init hook because deprecated in Rails 3.


## Release 0.2.0

- Releasing the library as open source project.


## Release 0.1.1


- NEW: documentation file.

- CHANGED: run test against Rails ~> 2.3.0 but ensure compatibility with Rails 2.2.x.
- CHANGED: Removed BUILD and STATUS constants. Added Version::ALPHA constant to be used when I need to package prereleases (see RubyGem --prerelease flag).


## Release 0.1.0

- Initial version
