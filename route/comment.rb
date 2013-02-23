# encoding: utf-8

require 'digest/md5'

class ElvenHut < Sinatra::Application

  def get_comment_list cur_comment_list, result_list
    cur_comment_list.each do |comment|
      result_list << comment
      get_comment_list comment.children, result_list
    end
  end

  def get_avatar_url email_addr
    hash = Digest::MD5.hexdigest email_addr.downcase
    "http://www.gravatar.com/avatar/#{hash}"
  end

  def process_website url
    if url =~ /https*:\/\//
      url
    else
      "http://" << url
    end
  end

  def comment_or_article opts
    msg = "<a href=\"#{opts[:url]}\"><b>#{opts[:title]}</b></a>.\n"
    if opts[:username] != Blog.admin_name
      msg = "<a href=\"#{opts[:comment_url]}\">your comment </a> at <a href=\"#{opts[:url]}\">#{opts[:url]}</a>\n"
    else
      opts[:subject] = "[#{Blog.url}] #{opts[:target_username]} replied the article"
    end

    msg << %Q{Here is the comment cotent:
  <pre>
    #{escape_html opts[:comment_content]}
  </pre>
}
  end

  def send_email(opts={})
    opts[:server]      ||= 'localhost'
    opts[:from]        ||= "notifications@#{Blog.url}"
    opts[:from_alias]  ||= "#{Blog.url} Notifications"
    opts[:subject]     ||= "[#{Blog.url}] #{opts[:target_username]} reply the comment posted by you"

    msg = %Q{Hi, #{opts[:username]}:

  <b>#{opts[:target_username]}</b> reply #{comment_or_article opts}

  <b>Please donnot reply this email.</b>

Best,
From #{Blog.url}
    }

    mail = Mail.new do
      from  opts[:from]
      to    opts[:to]
      subject opts[:subject]
      html_part do
        content_type 'text/html; charset=UTF-8'
        body msg.gsub("\n", '<br />')
      end
    end

    mail.delivery_method :sendmail
    mail.deliver
  end

  def is_email_available email_addr
    is_valid = false
    begin
      addr = Mail::Address.new(email_addr)
      is_valid = addr.domain && addr.address == email_addr
      t = addr.__send__(:tree)
      is_valid &&= (t.domain.dot_atom_text.elements.size > 1)
    rescue Exception => e
      is_valid = false
    end
  end

  def mail_send_thread comment, url, title
    opts = {}
    if comment.parent_id == -1
      opts[:to] = Blog.email
      opts[:username] = Blog.admin_name
    else
      comment_parent = Comment.filter(:id => comment.parent_id).first
      opts[:to] = comment_parent.email
      opts[:username] = comment_parent.author
      opts[:comment_url] = "#{url}#comment#{comment_parent.id.to_s}"
    end
    if is_email_available opts[:to]
      opts[:comment_content] = comment.comment
      opts[:title] = title
      opts[:url] = url
      opts[:target_username] = comment.author
      send_email opts
    else
      puts "invalid email address : \"#{opts[:to]}\""
    end
  end

  before %r{/archives/\d+/comment/d.*} do
    redirect "/not_auth" if !admin?
  end

  post '/archives/*/comment/r*' do
    article = Article.filter(:id => params[:splat][0].to_i).first
    not_found unless article
    comment = Comment.new :author => params[:name], :comment => params[:message], :email => params[:email], :website => process_website(params[:website]), :parent_id => params[:splat][1].to_i, :updated_at => Time.now, :ip => request.ip

    if Rakismet_Settings.use
      if !comment.spam?
        comment.save
        article.add_comment(comment)
        Thread.new {mail_send_thread(comment, "http://#{Blog.url}/archives/#{article.id.to_s}", article.title)} if Setting.reply_notificate
      end
    else
      comment.save
      article.add_comment(comment)
      Thread.new {mail_send_thread(comment, "http://#{Blog.url}/archives/#{article.id.to_s}", article.title)}
    end
    redirect "/archives/#{article.id}"
  end

  post '/archives/*/comment/d*' do
    article = Article.filter(:id => params[:splat][0].to_i).first
    not_found unless article
    comment = Comment.filter(:id => params[:splat][1].to_i).first
    article.remove_comment comment
    sub_comments = []
    get_comment_list [comment], sub_comments

    sub_comments.each do |sub_comment|
      sub_comment.destroy
    end
    redirect "/archives/#{article.id}"
  end
end
