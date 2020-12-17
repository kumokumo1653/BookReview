require 'active_record'
ActiveRecord::Base.configurations = YAML.load_file('./database/database.yml')
ActiveRecord::Base.establish_connection :development

ID = 15
TITLE = 30
AUTHOR = 30
PUBLISHER = 20
PUBLISHEDDATE = 15
DESCRIPTION = 300
class Book < ActiveRecord::Base
end

class Detail < ActiveRecord::Base
end

def cut(str, max)
    if(str.length > max)
        str = str.slice(0,max)
        str += "..."
    end
    return str
end

class Library
    def initialize
        @Lib = Book.all
        @Review = Detail.all
    end

    def Register(id, title, author, page, publishedDate, publisher, description)
        temp = ""
        begin
            author.each_with_index do |num, index|
                len = 0
                if(index == author.size - 1)
                    len += num.length
                    if(len > AUTHOR)
                        temp += "他"
                        break
                    end
                    temp += num
                else
                    len += num.length
                    if(len > AUTHOR)
                        temp += "他"
                        break
                    end
                    temp += num + ","
                end
            end
        rescue => exception
            puts(exception)
            return false
        end
        begin
            s = Book.new
            s.id = id.slice(0, ID)
            s.title = cut(title, TITLE)
            s.author = temp
            s.page = page
            s.publishedDate = cut(publishedDate, PUBLISHEDDATE)
            s.publisher = cut(publisher, PUBLISHER)
            s.description = cut(description, DESCRIPTION)
            s.rating = 0.0
            s.ratingnumber = 0
            s.wannanumber = 0
            s.recommendnumber = 0
            s.save
        rescue => exception
            puts exception
            puts "book has already registered"
            return false
        end
        return true
    end

    def Delete(id)
        begin
            a = Book.find(id)
            #該当の本のレビューを消す
            begin
                reviews = Detail.where(bookid:id)
                reviews.each do |s|
                    s.destroy
                end
            rescue => exception
                return
            end
            a.destroy
        rescue => exception
            puts exception
            puts "book #{id} is not found."
        end
    end

    def Show
        @Lib = Book.all
        @Lib.each do |a|
            puts a.id + "\t" + a.title + "\t" + a.rating.to_s + "\t" + a.wannanumber.to_s + "\t" + a.recommendnumber.to_s
        end
    end

    def GetBook(id) 
        begin
            return Book.find(id)
        rescue => exception
            return []
        end
    end

    def GetBooks
        return Book.all
    end
    def IsBook(id)
        a = Book.find_by(id:id)
        if a == nil
            return false
        else
            return true
        end
    end

end