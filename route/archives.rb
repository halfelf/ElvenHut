# encoding: utf-8

class ElvenHut < Sinatra::Application
  
  def database_clean
    Article.order("created_at DESC").each do |article|
      if !File.exist? File.join(settings.archive_path, article.id.to_s << ".md")
        article.tags.each do |tag|
          tag.quantity -= 1
          tag.save
        end
        article.destroy
      end
    end
  end

  def process_tag tags, article
    tags.split(',').each do |item|
      tag_name = item.strip || item if item
      tag = Tag.filter(:name => tag_name).first
      if tag == nil
        tag = Tag.new :name => tag_name, :quantity => 1
      else
        tag.quantity += 1
      end
      tag.save
      article.add_tag(tag)
    end
  end

  def write_mdfile filename, content
    File.open(File.join(settings.archive_path, filename << '.md'), "w:utf-8") do |write_stream|
      write_stream.write content
    end
  end

  get "/archives/" do
    begin
      @all = Article.reverse_order(:created_at)
      @archive_path = settings.archive_path
      erb :archives_index, :layout => :background
    rescue => e
      database_clean
      redirect "/archives/"
    end
  end

  get "/tag/:name" do
    @all = Tag.filter(:name => params[:name]).first.articles
    @archive_path = settings.archive_path
    erb :archives, :layout => :background
  end

  get %r{/archives/\d+$} do
    @article = Article.filter(:id => params[:captures].first).first
    not_found unless @article
    @contentfilepath = File.join(settings.archive_path, @article.id.to_s << '.md')
    erb :post, :layout=>:background
  end

  get "/new_post" do
    erb :edit_post, :layout => :background, :locals=>{:article=>Article.new}
  end

  post "/new_post" do
    article = Article.new :title => params[:title], :author => params[:author], :created_at => Time.now, :update_at => Time.new
    article.save

    process_tag params[:tags], article

    write_mdfile article.id.to_s, params[:content]
    redirect "/archives/#{article.id}"
  end

  get %r{/archives/([0-9]+)/delete$} do
    article = Article.filter(:id => params[:captures].first).first
    not_found unless article
    erb :delete_post, :layout => :background, :locals=>{:article=>article}
  end

  post %r{/archives/([0-9]+)/delete$} do
    article = Article.filter(:id => params[:captures].first).first
    not_found unless article
    article.tags.map{|tag| tag.quantity -= 1; tag.save}.each{|tag| article.remove_tag tag}
    md_filepath = File.join(settings.archive_path, article.id.to_s << ".md")
    File.delete md_filepath if File.exist? md_filepath
    article.destroy
    redirect "/archives/"
  end

  get %r{/archives/([0-9]+)/edit$} do
    article = Article.filter(:id => params[:captures].first).first
    not_found unless article
    erb :edit_post, :layout => :background, :locals=>{:article=>article}
  end

  post "/archives/:article_id/edit" do
    article = Article.filter(:id => params[:article_id]).first
    not_found unless article
    article.title = params[:title]
    article.author = params[:author]
    article.update_at = Time.new
    article.save

    article.tags.map{|tag| tag.quantity -= 1; tag.save}.each{|tag| article.remove_tag tag}

    process_tag params[:tags], article

    write_mdfile article.id.to_s, params[:content]
    redirect "/archives/#{article.id}"
  end

end
