# encoding: utf-8

require "sinatra"
require "rdiscount"

get "/" do 
    markdown :index
end


