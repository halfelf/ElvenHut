#encoding=utf-8
require "active_record"

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
        # return the whole text for rss feed

    end
end

#article = Article.new
#article.author = 'halfelf'
#article.title = 'test_title'
#article.created_at = Time.now
#article.updated_at = Time.now
#article.save
