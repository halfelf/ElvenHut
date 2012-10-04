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

  configure do
    require 'yaml'
    require 'ostruct'

    username = ENV['USER']  #linux/unix only, use "ENV['USERNAME']" on windows
    if File.exist?("config/config_#{username}.yaml")
      config = YAML.load_file root + "/config/config_#{username}.yaml"
    else
      config = YAML.load_file root + "/config/config.yaml"
    end

    Database = OpenStruct.new(
      :adapter => config["database"]["adapter"],
      :user => config["database"]["user"],
      :host => config["database"]["host"],
      :passwd => config["database"]["passwd"].to_s,
      :database => config["database"]["database"]
    )
    Sequel.connect(:adapter => Database.adapter, :user => Database.user, :host => Database.host, :database => Database.database, :password => Database.passwd);

    Blog = OpenStruct.new(
      :title => config["blog"]["title"],
      :site_name => config["blog"]["sitename"],
      :site_url => config["blog"]["url"],
      :site_description => config["blog"]["description"],
      :admin_name => config["blog"]["username"],
      :admin_passwd => config["blog"]["passwd"],
      :admin_cookie_key => config["blog"]["cookie_key"],
      :admin_cookie_value => config["blog"]["cookie_value"]
    )
  end

  use Rack::Session::Pool, :expire_after => 2592000
  require_relative "model/init"
  require_relative "route/init"
  require_relative "helpers/init"

end

