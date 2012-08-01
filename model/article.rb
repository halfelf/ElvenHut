#encoding=utf-8
require "active_record"
require "rdiscount"

ActiveRecord::Base.establish_connection(
    :adapter    =>  "mysql2",
    :encode     =>  "utf8",
    :host       =>  "localhost",
    :username   =>  "root",
    :password   =>  "123",
    :database   =>  "elvenhut"
)

class Article < ActiveRecord::Base
    def full_text
        # return the whole text in html format for rss feed
        @md = RDiscount.new(File.read( "views/archives/#{self.id}.md"  ))
        @md.to_html
    end
end

#article = Article.new
#article.author = 'halfelf'
#article.title = 'test_title'
#article.created_at = Time.now
#article.updated_at = Time.now
#article.save
