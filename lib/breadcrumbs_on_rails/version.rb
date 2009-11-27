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
# SVN: $Id$
#++


module BreadcrumbsOnRails

  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 0
    ALPHA = nil

    STRING = [MAJOR, MINOR, PATCH, ALPHA].compact.join('.')
  end

  VERSION = Version::STRING

end
