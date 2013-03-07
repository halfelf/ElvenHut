#source 'http://rubygems.org'
source "http://ruby.taobao.org"

require 'yaml'
username = ENV['USER']  #linux/unix only, use "ENV['USERNAME']" on windows
if File.exist?("config/config_#{username}.yaml")
  config = YAML.load_file "config/config_#{username}.yaml"
else
  config = YAML.load_file "config/config.yaml"
end

adapter = config["database"]["adapter"]

if adapter != "mysql2" && adapter != "sqlite3"
  err_msg = "Unkown adapter: \"#{adapter}\". Elvenhut only support sqlite3 and mysql2 now\nUse sqlite3 as default"
  puts "\e[31m#{err_msg}\e[0m"
  adapter = "sqlite3"
end

gem 'sinatra'
gem 'rake'
gem 'sequel'
gem 'rack-test'
gem 'builder'
gem 'redcarpet'
gem 'rakismet', "~> 1.3.0"
gem 'mail'
gem 'nokogiri'
gem "#{adapter}"
