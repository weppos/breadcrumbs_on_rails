require 'minitest/autorun'
require 'mocha/minitest'
require 'dummy'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'breadcrumbs_on_rails'

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
