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

  def process_website url
    if url =~ /https*:\/\// then
      url
    else
      url = "http://" + url
    end
  end

  post '/archives/*/comment/r*' do
    article = Article.filter(:id => params[:splat][0].to_i).first
    not_found unless article
    comment = Comment.new :author => params[:name], :comment => params[:message], :email => params[:email], :website => process_website(params[:website]), :parent_id => params[:splat][1].to_i, :updated_at => Time.now, :ip => request.ip

    if Rakismet_Settings.use then
      if !comment.spam? then
        comment.save
        article.add_comment(comment)
      end
    else
      comment.save
      article.add_comment(comment)
    end
    redirect "/archives/#{article.id}"
  end

  post '/archives/*/comment/d*' do
    article = Article.filter(:id => params[:splat][0].to_i).first
    not_found unless article
    comment = Comment.filter(:id => params[:splat][1].to_i).first
    article.remove_comment comment
    sub_comments = Array.new
    get_comment_list [comment], sub_comments

    sub_comments.each do |sub_comment|
      sub_comment.destroy
    end
    redirect "/archives/#{article.id}"
  end
end
