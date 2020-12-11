require 'sinatra'
require './database/user'
require './database/book'
require './database/review'

set :environment, :production
set :sessions,
    expire_after:7200,
    secret:'abcdefghij0123456789'

$user = User.new
$lib = Library.new
$review = Reviewer.new
get '/' do
    redirect '/login'
end

get '/login' do
    erb :loginscr
end

get '/registration' do
    erb :register
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

post '/request' do
    username = params[:name]
    pass = params[:pass]
    algorithm = 1
    result = $user.GenAccount(username, pass, algorithm)
    if(result)
        redirect '/success'
    else
        redirect '/registfail'
    end
end

get '/success' do
    erb :success
end

get '/registfail' do
    erb :registfail
end

get '/loginfail' do 
    erb :loginfail
end

get '/logout' do
    session.clear
    erb :logout
end

get '/mypage' do
    if(session[:login_flag] == true)
        @a = session[:testdata]
        erb :contents
    else
        erb :badrequest
    end
end

get '/book/:id' do
    id = params[:id]
    @reviews = $review.GetReview(id)
    @book = $lib.GetBook(id)
    erb :bookdetail
end