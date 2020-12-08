require 'active_record'
ActiveRecord::Base.configurations = YAML.load_file('./database/database.yml')
ActiveRecord::Base.establish_connection :development

class Book < ActiveRecord::Base
end

class Account < ActiveRecord::Base
end

class Detail < ActiveRecord::Base
end

class Reviewer
    def initialize
        @Lib = Book.all
        @Account = Account.all
        @Review = Detail.all
    end

    def Add(bookId, username, rating, comment)
        s = Detail.new
        book = nil
        user = nil

        begin
            book = Book.find(bookId)
        rescue => exception
            puts "book is not found"
            return -1
        end

        begin
            user = Account.find(username)
        rescue => exception
            puts "user is not found"
            return -1
        end

        begin
            s.id = book.id + user.id
            s.rating = rating
            s.comment = comment
            s.bookid = book.id
            s.name = user.id
            s.save
        rescue => exception
            puts "This review has already added"
            return    
        end

    end

    def Delete(id)
        begin
            s = Detail.find(id)
            s.destroy
        rescue => exception
            puts "review is not found"
        end
    end

    def Show
        @Review = Detail.all
        @Review.each do |a|
            puts a.bookid + "\t" + a.comment + "\t"
        end
    end
end