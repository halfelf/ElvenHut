xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Feeds from ElvenHut"
    xml.description "ElvenHut Blog Engine"
    xml.link "http://halfelf.me/feed"

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.link "http://localhost/archives/#{post.id}"
        xml.description post.full_text
        xml.pubDate post.created_at
        xml.guid "http://localhost/archives/#{post.id}"
      end
    end
  end
end
