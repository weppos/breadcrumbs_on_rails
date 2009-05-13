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
    TINY  = 0

    STRING = [MAJOR, MINOR, TINY].join('.')
  end

  VERSION         = Version::STRING
  STATUS          = 'alpha'
  BUILD           = ''.match(/(\d+)/).to_a.first

end
