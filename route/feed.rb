# encoding: utf-8

class ElvenHut < Sinatra::Application

  get "/feed" do
    @posts = Article.order("created_at DESC")
    builder :rss
  end

end
