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
end
