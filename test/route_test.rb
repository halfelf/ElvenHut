# encoding: utf-8

require_relative 'test_helper'
require 'route'

class RouteTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    ElvenHut
  end

  def test_its_index_page_is_ok
    get '/'
    assert last_response.ok?
    assert last_response.body.include?('ElvenHut')
  end

end
