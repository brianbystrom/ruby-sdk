require 'moltin/api'
require 'moltin/api/client'
require 'moltin/api/crud_resource'
require 'moltin/api/request'
require 'moltin/api/response'
require 'moltin/config'
require 'moltin/resource'
require 'moltin/resource/address'
require 'moltin/resource/cart'
require 'moltin/resource/checkout'
require 'moltin/resource/gateway'
require 'moltin/resource/product'
require 'moltin/resource_collection'
require 'moltin/support/inflector'
require "moltin/version"

if defined? Rails
  require 'moltin/rails'
end

module Moltin
end
