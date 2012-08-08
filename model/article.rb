#encoding=utf-8
require "active_record"
require "rdiscount"

class Article < Sequel::Model
  plugin :schema
  unless table_exists?
    set_schema do
      primary_key :id
      text :title
      text :content
      text :url
      text :tags
      text :author
      timestamp :update_at
    end
    create_table
  end

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
