# 
# = Breadcrumbs On Rails
#
# A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation.
# 
#
# Category::    Rails
# Package::     BreadcrumbsOnRails
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


module BreadcrumbsOnRails

  module Version
    MAJOR = 2
    MINOR = 0
    PATCH = 0
    BUILD = nil

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end

  VERSION = Version::STRING

end
