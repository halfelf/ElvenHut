xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
  xml.channel do
    xml.title Blog.site_name
    xml.description Blog.site_description
    xml.link Blog.url + "/feed"

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.link "#{Blog.url}/archives/#{post.id}"
        xml.description post.full_text
        xml.pubDate post.created_at
        xml.guid "#{Blog.url}/archives/#{post.id}"
      end
    end
  end
end
