require 'sinatra'
require 'json'
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
        session[:name] = username
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

post '/review' , provides: :json do
    params = JSON.load(request.body.read)
    begin
        book = params[0]
        review = params[1] 
        book.each{|key,value|
            puts key
            puts value.class
        }
        review.each{|key,value|
            puts key
            puts value.class
        }
        if(book[:id].class != String || book[:title].class != String || book[:author].class != Array || book[:page].class != Integer || book[:publishedDate].class != String || book[:publisher].class != String || book[:description].class != Srting)
            puts (book[:id]).class
            puts "book info is wrong"
            status 400
        elsif (review[:username].class != String || review[:rating].class != Integer || review[:comment].class != String || 
            !(review[:wanna].class == TrueClass || review[:wanna].class == FalseClass) || !(review[:recommend].class == TrueClass || review[:recommend].class == FalseClass))
            puts "review info is wrong"
            status 400
        else
            $lib.Register(book[:id], book[:title], book[:author], book[:page], book[:publishedDate], book[:publisher], book[:description])
            $review.Add(book[:id], review[:username], review[:rating], review[:comment], review[:wanna],review[:recommend])
            status 200
        end
    rescue => exception
        puts exception
        status 400
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
        @a = session[:name]
        erb :contents
    else
        erb :badrequest
    end
end

get '/book/:id' do
    if(session[:login_flag] == true)
        @name = session[:name]
        id = params[:id]
        temp = $review.GetReview(id)
        @reviews = []
        #コメントありのみを抽出
        for i in temp
            if i.comment != ""
                @reviews.push(i)
            end
        end
        @book = $lib.GetBook(id)
        erb :bookdetail
    else
        erb :badrequest
    end
end