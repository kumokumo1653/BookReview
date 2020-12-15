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
        redirect '/loginfail'
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
        type = params[0]
        #型検知
        if (type["type"] == "add")
            book = params[1]
            review = params[2] 
            book.each{|key,value|
                if (key == "author")
                    if (value.class != Array)
                        puts "book info is wrong"
                        status 400
                        return
                    end
                elsif (key == "page")
                    if(value.class != Integer)
                        puts "book info is wrong"
                        status 400
                        return
                    end
                else
                    if(value.class != String)
                        puts "book info is wrong"
                        status 400
                        return
                    end
                end
            }

            review.each{|key,value|
                if (key == "rating")
                    if (value.class != Integer)
                        puts "review info is wrong"
                        status 400
                        return
                    end
                elsif (key == "wanna" || key == "recommend")
                    if(!(value.class == TrueClass || value.class == FalseClass))
                        puts "review info is wrong"
                        status 400
                        return
                    end
                else
                    if(value.class != String)
                        puts "review info is wrong"
                        status 400
                        return
                    end
                end
            }
            if !$lib.IsBook(book["id"])
                if $lib.Register(book["id"], book["title"], book["author"], book["page"], book["publishedDate"], book["publisher"], book["description"]) == false
                    status 400
                    return
                end
            end
            wanna = review["wanna"] ? 1 : 0
            recommend = review["recommend"] ? 1 : 0
            if $review.Add(book["id"], review["username"], review["rating"], review["comment"], wanna, recommend) == false
                status 400
                return
            end
        elsif (type["type"] == "change")
            review = params[1]
            review.each{|key,value|
                if (key == "rating")
                    if (value.class != Integer)
                        puts "review info is wrong"
                        status 400
                        return
                    end
                elsif (key == "wanna" || key == "recommend")
                    if(!(value.class == TrueClass || value.class == FalseClass))
                        puts "review info is wrong"
                        status 400
                        return
                    end
                else
                    if(value.class != String)
                        puts "review info is wrong"
                        status 400
                        return
                    end
                end
            }
            wanna = review["wanna"] ? 1 : 0
            recommend = review["recommend"] ? 1 : 0
            if $review.Change(review["id"], review["rating"], review["comment"], wanna, recommend) == false
                status 400
                return
            end

        elsif (type["type"] == "delete")
            id = params[1]["id"]
            if(id.class != String)
                puts "review info is wrong"
                status 400
                return
            end
            if $review.Delete(id) == false
                status 400
                return
            end
        end

        status 200
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
        @writingFlag = false
        @name = session[:name]
        id = params[:id]
        temp = $review.GetReview(id)
        @reviews = []
        #コメントありのみを抽出
        for i in temp
            if i.name == @name
                @writingFlag = true
                @mywriting = i
            elsif i.comment != ""
                @reviews.push(i)
            end
        end
        @book = $lib.GetBook(id)
        erb :bookdetail
    else
        erb :badrequest
    end
end