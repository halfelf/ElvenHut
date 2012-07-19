# encoding: utf-8

require "sinatra/base"
require "rdiscount"
require "erb"


Sinatra::Base.set :markdown, :layout_engine => :erb, :layout => :background

class ElvenHut < Sinatra::Base
    root = File.dirname(__FILE__)
    view_path = root + "/views/"
    public_path = root + "/public/"

    get "/" do 
        if File.exist?(view_path + "my_index.md")
            markdown :my_index
        else
            markdown :index
        end
    end

    run!
end

