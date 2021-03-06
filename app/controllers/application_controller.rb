require './config/environment'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :session_secret, "purplepandageneral"
  set :views, Proc.new { File.join(root, "../views/") }
  set :show_exceptions, false
  
  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "purplepandageneral"
    register Sinatra::Flash
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :welcome
  end

  error do
    erb :oops
  end

  helpers do
    def logged_in?
      !!current_user
    end
    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end
    def redirect_if_logged_out
      redirect to '/' unless logged_in?
    end
  end
end
