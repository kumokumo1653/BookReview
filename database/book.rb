require 'active_record'
ActiveRecord::Base.configurations = YAML.load_file('./database/database.yml')
ActiveRecord::Base.establish_connection :development

class Book < ActiveRecord::Base
end

class Detail < ActiveRecord::Base
end

class Library
    def initialize
        @Lib = Book.all
        @Review = Detail.all
    end

    def Register(id, title, author, page, publishedDate, publisher, description)
        begin
            s = Book.new
            s.id = id
            s.title = title
            s.author = author
            s.page = page
            s.publishedDate = publishedDate
            s.publisher = publisher
            s.description = description
            s.rating = 0.0
            s.ratingnumber = 0
            s.wannanumber = 0
            s.recommendnumber = 0
            s.save
        rescue => exception
            puts "book has already registered"
        end
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
end