# encoding: utf-8

require "sinatra/base"
require "redcarpet"
require "erb"
require "sequel"
require "rakismet"
require "mail"
require "fileutils"

Sinatra::Base.set :markdown, 
                  :autolink => true,
                  :fenced_code_blocks => true, 
                  :strikethrough => true,
                  :superscript => true,
                  :layout_engine => :erb
class ElvenHut < Sinatra::Application

  Tilt.register Tilt::RedcarpetTemplate::Redcarpet2, 'markdown', 'mkd', 'md'

  set :root, File.dirname(__FILE__)
  set :view_path => File.join(root,'views')
  set :public_path => File.join(root,'public')
  set :archive_path => File.join(root,'views','archives')
  set :port, 80

  layout 'background'

  include Rack::Utils
  require_relative "helpers/init"

  configure do
    require 'yaml'
    require 'ostruct'

    username = ENV['USER']  #linux/unix only, use "ENV['USERNAME']" on windows
    if File.exist?("config/config_#{username}.yaml")
      config_file = File.join(root,"/config/config_#{username}.yaml")
    else
      config_file = File.join(root,"/config/config.yaml")
    end
    config = YAML.load_file config_file
    config_struct = config.to_struct

    Database = config_struct["database"].to_struct
    Blog = config_struct["blog"].to_struct
    Social = config_struct["social"].to_struct
    Setting = config_struct["basic_setting"].to_struct
    Rakismet_Settings = config_struct["rakismet"].to_struct

    if Database.adapter == "mysql2"
      Sequel.connect(:adapter => Database.adapter, :user => Database.user, :host => Database.host, :database => Database.database, :password => Database.passwd.to_s, :encoding => 'utf8');
    elsif Database.adapter == "sqlite3"
      Sequel.connect(:adapter => "sqlite", :database => "db/#{Database.database}.db")
    end

    if Rakismet_Settings.use then
      Rakismet.key = Rakismet_Settings.key
      Rakismet.url = Rakismet_Settings.url
      Rakismet.host = Rakismet_Settings.host
    end
  end

  use Rack::Session::Pool, :expire_after => 2592000
  require_relative "model/init"
  require_relative "route/init"

end
