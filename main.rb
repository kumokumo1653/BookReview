require 'sinatra'
require './database/user'
require './database/book'
require './database/review'

set :environment, :production
set :sessions,
    expire_after:7200,
    secret:'abcdefghij0123456789'

$user = User.new
get '/' do
    redirect '/login'
end

get '/login' do
    erb :loginscr
end
post '/auth' do
    username = params[:uname]
    pass = params[:pass]
    result,date = $user.CheckAccount(username, pass)

    if(result)
        session[:login_flag] = true
        session[:testdata] = date
        redirect '/mypage'
    else
        session[:login_flag] = false
        redirect '/failure'
    end
end

get '/failure' do 
    erb :failure
end

get '/mypage' do
    if(session[:login_flag] == true)
        @a = session[:testdata]
        erb :contents
    else
        erb :badrequest
    end
end

get '/logout' do
    session.clear
    erb :logout
end
