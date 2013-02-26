# encoding: utf-8

class ElvenHut < Sinatra::Application

  get "/" do 
    if File.exist?(settings.view_path + "my_index.md")
      markdown :my_index, :layout => :background
    else
      markdown :index, :layout => :background
    end
  end

  not_found do
    markdown File.read(File.join(settings.public_path,"not_found.md")), :layout => :background
  end

end
