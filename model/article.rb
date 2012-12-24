#encoding=utf-8
require "sequel"
require "redcarpet"

class Article < Sequel::Model
  plugin :schema
  many_to_many :tags#, :left_key => :articleid, :right_key => :tagid, :join_table => :articletags
  one_to_many :comments

  def url
    puts url
    "article/#{url}"
    puts "right"
  end

  def full_text
    # return the whole text in html format for rss feed
    @render = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                      :autolink => true,
                                      :fenced_code_blocks => true,
                                      :strikethrough => true,
                                      :superscript => true)
    @render.render File.read("views/archives/#{self.id}.md")
  end
end
