require 'sinatra'
require 'json'
require './database/user'
require './database/book'
require './database/review'
require 'cgi/escape'

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
    erb :auth
end


post '/auth' , provides: :json do
    params = JSON.load(request.body.read) 
    begin
        if(params.size != 2)    
            status 400
            return 
        end
        type = params[0]
        if(type["type"] == "login")
            info = params[1]
            if info.empty?
                status 400
                return 
            end
            info.each{|key,value|
                if(key == "name" || key == "pass")
                    if(value.class != String)
                        status 400
                        puts "info is wrong"
                        return
                    end
                else
                    status 400
                    puts "info is wrong"
                    return
                end
            }
            #check
            result = $user.CheckAccount(info["name"], info["pass"])
            if (result)
                session[:login_flag] = true
                session[:name] = info["name"]
                status 200
                return 
            else
                session[:login_flag] = false
                status 400
                return
            end
        elsif (type["type"] == "register")
            info = params[1]
            if info.empty?
                status 400
                return 
            end
            info.each{|key,value|
                if(key == "name" || key == "pass")
                    if(value.class != String)
                        status 400
                        puts "info is wrong"
                        return
                    end
                else
                    status 400
                    puts "info is wrong"
                    return
                end
            }
            #generate
            result = $user.GenAccount(info["name"], info["pass"],1)
            if (result)
                status 200
                return 
            else
                status 400
                return
            end
        end
    rescue => exception
        puts exception
        status 400
        return 
    end
end

post '/review' , provides: :json do
    params = JSON.load(request.body.read)
    begin
        type = params[0]
        #型検知
        if (type["type"] == "add")
            if(params.size != 3)    
                status 400
                return 
            end

            book = params[1]
            review = params[2] 
            if book.empty?
                status 400
                return 
            end
            if review.empty?
                status 400
                return 
            end
            if book.size != 7
                puts "book info is wrong"
                status 400
                return 
            end
            book.each{|key,value|
                puts key
                puts value.class
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
                elsif(key == "id" || key == "title" || key == "publishedDate" || key == "publisher" || key == "description")
                    if(value.class != String)
                        puts "book info is wrong"
                        status 400
                        return
                    end
                else
                    status 400
                    return    
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
                elsif (key == "username" || key == "comment")
                    if(value.class != String)
                        puts "review info is wrong"
                        status 400
                        return
                    end
                else
                    status 400
                    return
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
            if(params.size != 2)    
                status 400
                return 
            end
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
                elsif (key == "id" || key == "comment")
                    if(value.class != String)
                        puts "review info is wrong"
                        status 400
                        return
                    end
                else
                    status 400
                    return
                end
            }
            wanna = review["wanna"] ? 1 : 0
            recommend = review["recommend"] ? 1 : 0
            if $review.Change(review["id"], review["rating"], review["comment"], wanna, recommend) == false
                status 400
                return
            end

        elsif (type["type"] == "delete")
            if(params.size != 2)    
                status 400
                return 
            end
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
        else
            status 400
            return
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


get '/logout' do
    session.clear
    erb :logout
end

get '/fail'do
    erb :fail
end

post '/delete' ,provides: :json do
    params = JSON.load(request.body.read)
    begin
        if(params.size == 1)
            if(params[0]["type"] == "delete")
                #delete
                if $user.DelAccount(session[:name])
                    status 200
                    return 
                end
            end
        end
    rescue => exception
        puts exception
        status 400
        return 
    end
    status 400
    return 
end
get '/mypage' do
    if(session[:login_flag] == true)
        @name = session[:name]
        @wannaBook = []
        @recommendBook = []
        temp = $review.GetReviewByUser(@name)

        for i in temp
            if (i.wannaread == 1)
                book = $lib.GetBook(i.bookid)
                if(book != [])
                    @wannaBook.push(book)
                end
            end
        end
        temp = $lib.GetBooks
        for i in temp
            if (i.recommendnumber >= 1 && i.rating >= 3.0)
                @recommendBook.push(i)
            end
        end
        @recommendBook = @recommendBook.shuffle
        @recommendBook = @recommendBook.slice(0,10)
        erb :contents
    else
        erb :badrequest
    end
end

get '/book/:id' do
    if(session[:login_flag] == true)
        @writingFlag = false
        @name = session[:name]
        @book = $lib.GetBook(params[:id])
        @searchFlag = false
        if(@book == [])
            @searchFlag = true
        else
            #評価を小数点以下一桁に
            @book.rating = @book.rating.round(1)
        end
        id = params[:id]
        temp = $review.GetReviewByBook(id)
        @reviews = []
        #コメントありのみを抽出
        for i in temp
            if i.name == @name
                @writingFlag = true
                @mywriting = i
            elsif i.comment != ""
                i.comment = CGI.escapeHTML(i.comment)
                @reviews.push(i)
            end
        end
        erb :bookdetail
    else
        erb :badrequest
    end
end