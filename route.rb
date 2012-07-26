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

    not_found do
        markdown :not_found
    end

    run!
end

