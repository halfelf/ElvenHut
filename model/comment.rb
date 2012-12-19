#encoding: UTF-8
require "sequel"

class Comment < Sequel::Model
  plugin :schema
  many_to_one :articles
  many_to_one :parent, :class=>self
  one_to_many :children, :key=>:parent_id, :class=>self
end
