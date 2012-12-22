# encoding: UTF-8

class ElvenHut < Sinatra::Application
  post %r{/archives/([0-9]+)/comment$} do
    article = Article.filter(:id => params[:captures].first).first
    not_found unless article
    comment = Comment.new :author => params[:name], :comment => params[:message], :email => params[:email], :website => params[:website], :parent_id => -1, :updated_at => Time.now
    comment.save

    article.add_comment(comment)
    redirect "/archives/#{article.id}"
  end

  post '/archives/*/comment/r*' do
    p params[:splat]
    article = Article.filter(:id => params[:splat][0].to_i).first
    not_found unless article
    comment = Comment.new :author => params[:name], :comment => params[:message], :email => params[:email], :website => params[:website], :parent_id => params[:splat][1].to_i, :updated_at => Time.now
    comment.save

    comment_parent = Comment.filter(:id => params[:splat][1].to_i).first
    not_found unless article

    article.add_comment(comment)
    redirect "/archives/#{article.id}"
  end
end
