# encoding: utf-8

require "sinatra/base"
require "rdiscount"
require "erb"


Sinatra::Base.set :markdown, :layout_engine => :erb, :layout => :background

class ElvenHut < Sinatra::Base
    root = File.dirname(__FILE__)
    view_path = root + "/views/"
    public_path = root + "/public/"
    archive_path = "archive/"

    get "/" do 
        if File.exist?(view_path + "my_index.md")
            markdown :my_index
        else
            markdown :index
        end
    end

    get "/archives/:md" do
        md_file = File.read(root + view_path + archive_path + "#{params[:md]}.md")
        if File.exist? md_file
            markdown md_file
        else
            markdown public_path + "404.md"
        end
    end

    run!
end

