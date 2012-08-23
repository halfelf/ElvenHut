#encoding=utf-8
require "sequel"
require "rdiscount"

class Article < Sequel::Model
  plugin :schema

  def url
    puts url
    "article/#{url}"
    puts "right"
  end

  def full_text
    # return the whole text in html format for rss feed
    @md = RDiscount.new(File.read( "views/archives/#{self.id}.md"  ))
    @md.to_html
  end
end
