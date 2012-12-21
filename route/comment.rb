# encoding: UTF-8

class ElvenHut < Sinatra::Application
  post %r{/archives/([0-9]+)/comment$} do
    article = Article.filter(:id => params[:captures].first).first
    not_found unless article
    comment = Comment.new :comment => params[:message], :email => params[:email], :website => params[:website], :updated_at => Time.new
    comment.save

    article.add_comment(comment)
    redirect "/archives/#{article.id}"
  end
end
