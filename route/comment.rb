# encoding: UTF-8
require 'digest/md5'

class ElvenHut < Sinatra::Application
  def getCommentList currentCommentList, resultList
    currentCommentList.each do |comment|
      resultList << comment
      tempCommentList = comment.children
      getCommentList tempCommentList, resultList
    end
  end

  def getAvatarURL email_addr
    hash = Digest::MD5.hexdigest email_addr.downcase
    "http://www.gravatar.com/avatar/#{hash}"
  end
=begin
  post %r{/archives/([0-9]+)/comment$} do
    article = Article.filter(:id => params[:captures].first).first
    not_found unless article
    comment = Comment.new :author => params[:name], :comment => params[:message], :email => params[:email], :website => params[:website], :parent_id => -1, :updated_at => Time.now
    comment.save

    article.add_comment(comment)
    redirect "/archives/#{article.id}"
  end
=end

  post '/archives/*/comment/r*' do
    p params[:splat]
    article = Article.filter(:id => params[:splat][0].to_i).first
    not_found unless article
    comment = Comment.new :author => params[:name], :comment => params[:message], :email => params[:email], :website => params[:website], :parent_id => params[:splat][1].to_i, :updated_at => Time.now
    comment.save

    article.add_comment(comment)
    redirect "/archives/#{article.id}"
  end
end
