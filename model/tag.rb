#encoding=utf-8
require "sequel"

class Tag < Sequel::Model
  plugin :schema
  many_to_many :articles#, :left_key => :tagid, :right_key => :articleid, :join_table => :articletags
end
