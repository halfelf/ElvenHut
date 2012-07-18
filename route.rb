# encoding: utf-8

require "sinatra"
require "rdiscount"
require "erb"

root = File.dirname(__FILE__)
view_path = root + "/views/"
public_path = root + "/public/"

set :markdown, :layout_engine => :erb, :layout => :background

get "/" do 
    if File.exist?(view_path + "my_index.md")
        markdown :my_index
    else
        markdown :index
    end
end


