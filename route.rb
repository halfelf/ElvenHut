# encoding： UTF-8

require "sinatra/base"
require "rdiscount"
require "erb"
require_relative "model/article"

Sinatra::Base.set :markdown, :layout_engine => :erb, :layout => :background

class ElvenHut < Sinatra::Base
    root = File.dirname(__FILE__)
    view_path = root + "/views/"
    public_path = root + "/public/"
    archive_path = "archives/"

    layout 'background'

    configure do
        require 'yaml'
        require 'ostruct'

        config = YAML.load_file root + "/config.yaml"
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

    def admin?
        request.cookies[Blog.admin_cookie_key] == Blog.admin_cookie_value
    end

    def auth
        markdown not_auth unless admin?
    end

    get "/" do 
        if File.exist?(view_path + "my_index.md")
            markdown :my_index
        else
            markdown :index
        end
    end

    get "/archives/" do
        @all = Article.order("created_at DESC")
        erb :archives_index, :layout => :background
    end

    get "/archives/:md" do
        md_file = archive_path + "#{params[:md]}"
        markdown :"#{md_file}"
    end

    get "/feed" do
        @posts = Article.order("created_at DESC")
        builder :rss
    end

    get "/login" do
        erb :login, :layout=> :background
    end

    post "/login" do
        if params[:username] == Blog.admin_name && params[:password] == Blog.admin_passwd then
            response.set_cookie(Blog.admin_cookie_key, Blog.admin_cookie_value)
            redirect '/'
        else
            markdown :not_auth
        end
    end

    not_found do
        markdown :not_found
    end

    run!
end

