# encoding: utf-8

class ElvenHut < Sinatra::Application
  require "hpricot"
  require "time"

  wordpress_archives = nil

  def extract_wordpressxml xmlfile
    parser = Hpricot(File.open(xmlfile))
    archives = Array.new
    (parser/"item").each do |item|
      post = Hash.new
      post[:title] = item.search("title").inner_text
      post[:author] = item.search("dc:creator").first.inner_text
      post[:create_at] = Time.parse(item.search("wp:post_date").inner_text)
      post[:content] = item.search("content:encoded").inner_text
      post[:tags] = item.search("category").collect(&:inner_text).join(",")
      comments = Array.new
      (item/"wp:comment").each do |comment|
        comment_struct = Hash.new
        comment_struct[:id] = comment.search("wp:comment_id").inner_text.to_i
        comment_struct[:parent_id] = comment.search("wp:comment_parent").inner_text.to_i
        comment_struct[:author] = comment.search("wp:comment_author").inner_text
        comment_struct[:email] = comment.search("wp:comment_author_email").inner_text
        comment_struct[:url] = comment.search("wp:comment_author_url").inner_text
        comment_struct[:create_at] = Time.parse(comment.search("wp:comment_date").inner_text)
        comment_struct[:comment] = comment.search("wp:comment_content").inner_text
        comment_struct[:ip] = comment.search("wp:comment_author_IP").inner_text
        comments << comment_struct
      end
      post[:comments] = comments
      archives << post
    end
    archives
  end

  def import_archive post
    article = Article.new :title => post[:title], :author => post[:author], :created_at => post[:create_at], :update_at => post[:create_at]
    article.save

    process_tag post[:tags], article
    write_mdfile article.id.to_s, post[:content]

    comment_id_map = Hash.new
    current_comment = nil
    post[:comments].each do |comment|
      current_comment = Comment.new :author => comment[:author], :comment => comment[:comment], :email => comment[:email], :website => process_website(comment[:url]), :parent_id => -1, :updated_at => comment[:create_at], :ip => comment[:ip]
      current_comment.save
      article.add_comment(current_comment)
      comment_id_map[comment[:id]] = current_comment
    end
    post[:comments].each do |comment|
      if comment[:parent_id] != 0
        comment_id_map[comment[:id]].parent_id = comment_id_map[comment[:parent_id]].id
        comment_id_map[comment[:id]].save
      end
    end
  end

  get "/import_archives" do
    erb :import_archives, :layout => :background, :locals => {:step => 1}
  end

  post "/import_xml" do
    redirect "/import_archives" if params['file'] == nil
    tempfile = params['file'][:tempfile]
    filename = params['file'][:filename]
    FileUtils.copy(tempfile.path, filename)
    wordpress_archives = (extract_wordpressxml filename)
    erb :import_archives, :layout => :background, :locals => {:step => 2, :archives => wordpress_archives}
  end

  post "/import_archives" do
    params[:index].each do |index|
      import_archive wordpress_archives[index.to_i]
    end
    wordpress_archives = nil
    redirect "/archives"
  end
end
