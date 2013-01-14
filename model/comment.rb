# encoding: utf-8

require "sequel"

class Comment < Sequel::Model
  plugin :schema
  many_to_one :articles
  many_to_one :parent, :class=>self
  one_to_many :children, :key=>:parent_id, :class=>self

  include Rakismet::Model
  rakismet_attrs :author_email => :email, :content => :comment, :user_ip => :ip
end
