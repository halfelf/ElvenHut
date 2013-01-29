# encoding: utf-8

class ElvenHut < Sinatra::Application

  before %r{(/new_post)|(/[0-9]*/edit)|(/[0-9]*/delete)|(import_.*)|(/archives/[0-9]*/comment/d.*)} do
    redirect "/not_auth" if !admin?
  end

  def admin?
    session[:username] == Blog.admin_name && session[:password] == Blog.admin_passwd
  end

  get "/login" do
    erb :login, :layout=> :background
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  post "/login" do
    if params[:username] == Blog.admin_name && params[:password] == Blog.admin_passwd
      session[:username] = params[:username]
      session[:password] = params[:password]
      #response.set_cookie(Blog.admin_cookie_key, Blog.admin_cookie_value)
      redirect '/'
    else
      markdown :not_auth, :layout => :background
    end
  end

  get "/not_auth" do
    markdown :not_auth, :layout => :background
  end

end
