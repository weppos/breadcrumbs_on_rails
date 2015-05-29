#--
# Breadcrumbs On Rails
#
# A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++

module BreadcrumbsOnRails

  module Version
    MAJOR = 2
    MINOR = 5
    PATCH = 0
    BUILD = nil

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end

  VERSION = Version::STRING

end
