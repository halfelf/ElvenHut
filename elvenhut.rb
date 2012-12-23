# encoding： UTF-8

require "sinatra/base"
require "rdiscount"
require "erb"
require "sequel"

Sinatra::Base.set :markdown, :layout_engine => :erb
class ElvenHut < Sinatra::Application
  set :root, File.dirname(__FILE__)
  set :view_path => root + "/views/"
  set :public_path => root + "/public/"
  set :archive_path => root + "/views/archives/"

  layout 'background'

  require_relative "helpers/init"

  configure do
    require 'yaml'
    require 'ostruct'

    username = ENV['USER']  #linux/unix only, use "ENV['USERNAME']" on windows
    if File.exist?("config/config_#{username}.yaml")
      config = YAML.load_file root + "/config/config_#{username}.yaml"
    else
      config = YAML.load_file root + "/config/config.yaml"
    end
    config_struct = config.to_struct

    Database = config_struct["database"].to_struct
    Blog = config_struct["blog"].to_struct
    Social = config_struct["social"].to_struct
    Setting = config_struct["basic_setting"].to_struct

    Sequel.connect(:adapter => Database.adapter, :user => Database.user, :host => Database.host, :database => Database.database, :password => Database.passwd.to_s, :encoding => 'utf8');
  end

  use Rack::Session::Pool, :expire_after => 2592000
  require_relative "model/init"
  require_relative "route/init"

end
