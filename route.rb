# encoding： UTF-8

require "sinatra/base"
require "rdiscount"
require "erb"
require "sequel"

Sinatra::Base.set :markdown, :layout_engine => :erb
class ElvenHut < Sinatra::Base
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

  helpers do
    def current_folder?(path="")
      'class="active"' if request.path_info =~ Regexp.new(path)
    end

    def current_page?(path="")
      'class="active"' if request.path_info == path
    end

    def parse_date origin_date
      origin_date.strftime("%b %d, %Y")
    end
  end

  use Rack::Session::Pool, :expire_after => 2592000
  require_relative "model/article"
  require_relative "model/tag"

  before '/new_post' do
    redirect "/not_auth" if !admin?
  end

  def admin?
	  !(request.cookies[Blog.admin_cookie_key] != Blog.admin_cookie_value)
  end

  def database_clean
    Article.order("created_at DESC").each do |article|
      if !File.exist? settings.archive_path + article.id.to_s + ".md" then
        article.tags.each do |tag|
          tag.quantity -= 1
          tag.save
        end
        article.destroy
      end
    end

    Tag.order("created_at DESC").each do |tag|
      tag.destroy if tag.quantity == 0
    end
  end

  get "/" do 
    if File.exist?(settings.view_path + "my_index.md")
      markdown :my_index, :layout => :background
    else
      markdown :index, :layout => :background
    end
  end

  get "/archives/" do
    begin
      @all = Article.order("created_at DESC")
      @archive_path = settings.archive_path
      erb :archives_index, :layout => :background
    rescue => e
      database_clean
      redirect "/archives/"
    end
  end

  get "/tag/:name" do
    @all = Tag.filter(:name => params[:name]).first.articles
    @archive_path = settings.archive_path
    erb :archives_index, :layout => :background
  end

  get "/archives/:id" do
    @article = Article.filter(:id => params[:id]).first
    not_found unless @article
    @contentfilepath = "#{settings.archive_path + @article.id.to_s}.md"
    erb :post, :layout=>:background
  end

  get "/new_post" do
    erb :new_post, :layout => :background
  end

  post "/new_post" do
    article = Article.new :title => params[:title], :author => params[:author], :created_at => Time.now, :update_at => Time.new
    article.save

    params[:tags].split(/,/).each do |item|
      tag_name = item.strip! || item if item
      tag = Tag.filter(:name => tag_name).first
      if tag == nil then
        tag = Tag.new :name => tag_name, :quantity => 1
      else
        tag.quantity += 1
      end
      tag.save
      article.add_tag(tag)
    end

    writeStream = File.new("#{settings.archive_path + article.id.to_s}.md", 'w')
    writeStream.write params[:content]
    writeStream.close
    redirect "/archives/#{article.id}"
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
      markdown :not_auth, :layout => :background
    end
  end

  get "/not_auth" do
    markdown :not_auth, :layout => :background
  end

  not_found do
    markdown File.read("#{settings.public_path}not_found.md"), :layout => :background
  end

end

