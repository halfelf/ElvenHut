# encoding: utf-8

require_relative 'basic_method'
ElvenHut.helpers BasicMethods

helpers do
  include Rack::Utils
end
