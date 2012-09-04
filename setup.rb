#!ruby -w
#encoding=utf-8

require 'yaml'

config = YAML.load_file "config/config.yaml"

adapter = config["database"]["adapter"]
database = config["database"]["database"]
user = config["database"]["user"]
host = config["database"]["host"]
passwd = config["database"]["passwd"]

sequel_command = "sequel -m db/migration #{adapter}://#{user}:#{passwd}@#{host}/#{database}"
system sequel_command
