# encoding: utf-8

require 'digest/md5'

class ElvenHut < Sinatra::Application
  def get_comment_list cur_comment_list, result_list
    cur_comment_list.each do |comment|
      result_list << comment
      temp_comment_list = comment.children
      get_comment_list temp_comment_list, result_list
    end
  end

  def get_avatar_url email_addr
    hash = Digest::MD5.hexdigest email_addr.downcase
    "http://www.gravatar.com/avatar/#{hash}"
  end

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
