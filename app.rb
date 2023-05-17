require 'sinatra/base'
require 'kramdown'
require_relative './runner'

class App < Sinatra::Base
  enable :sessions

  get '/' do
    @readme = Kramdown::Document.new( File.read( "readme.md")).to_html
    erb :index
  end
  
  get '/inline' do
    auth_check do
      if params[:arg1]
        @runner = Runner.inline( ["./immediate", params[:arg1]] )
      end

      if request.env['HTTP_HX_TARGET'] == 'results'
        erb :results, layout: nil
      else
        erb :inline
      end
    end
  end

  get '/fs_polling' do
    auth_check do
      if params[:arg1]
        @runner = Runner.filesystem( ["./delayed", params[:arg1]] )
      end

      if request.env['HTTP_HX_TARGET'] == 'results'
        erb :results, layout: nil
      else
        erb :fs_polling
      end
    end
  end


  get '/redis_polling' do
    auth_check do
      if params[:arg1]
        @runner = Runner.redis( ["./delayed", params[:arg1]] )
      end

      if request.env['HTTP_HX_TARGET'] == 'results'
        erb :results, layout: nil
      else
        erb :redis_polling
      end
    end
  end


  # Login Stuff

  get '/login' do
    erb :login
  end

  post '/login' do
    # Add auth logic here

    session[:password] = params[:password] == ENV['MINISTER_PASSWORD']

    if !session[:password]
      @error = "Wrong password"
      erb :login
    else
      path = session.delete :redirect_to
      redirect path
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  private
  def auth_check
    return yield unless ENV['MINISTER_PASSWORD']
    unless session[:password]
      session[:redirect_to] = request.path_info
      redirect '/login'
    else
      return yield
    end
  end
end