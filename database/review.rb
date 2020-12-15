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

    def Add(bookId, username, rating, comment, wannaread, recommend)
        s = Detail.new
        book = nil
        user = nil

        begin
            book = Book.find(bookId)
        rescue => exception
            puts "book is not found"
            return false
        end

        begin
            user = Account.find(username)
        rescue => exception
            puts "user is not found"
            return false
        end

        begin
            s.id = book.id + user.id
            s.rating = rating
            s.comment = comment
            s.wannaread = wannaread
            s.recommend = recommend
            s.bookid = book.id
            s.name = user.id
            s.save
            #レビューの更新
            if(rating != 0)
                    book.rating = (book.rating * book.ratingnumber + rating) / (book.ratingnumber + 1)
                    book.ratingnumber += 1
            end
            if wannaread == 1
                book.wannanumber += 1
            end
            if recommend == 1
                book.recommendnumber += 1
            end
            book.save
        rescue => exception
            puts "This review has already added"
            return false 
        end
        return true
    end

    def Change(id, rating, comment, wannaread, recommend)
        begin
            s = Detail.find(id)
            #レビューの更新
            book = Book.find(s.bookid)
            if(rating == 0)
                if (book.ratingnumber == 1)
                    book.rating = 0
                    book.ratingnumber = 0
                else
                    book.rating = (book.rating * book.ratingnumber - s.rating + rating) / (book.ratingnumber - 1)
                    book.ratingnumber -= 1
                end
            else 
                book.rating = (book.rating * book.ratingnumber - s.rating + rating) / (book.ratingnumber)
            end

            if wannaread == 1 && s.wannaread == 0
                book.wannanumber += 1
            end
            if wannaread == 0 && s.wannaread == 1
                book.wannanumber -= 1
            end
            if recommend == 1 && s.recommend == 0
                book.recommendnumber += 1
            end
            if recommend == 0 && s.recommend == 1
                book.recommendnumber -= 1
            end
            book.save

            s.rating = rating
            s.comment = comment
            s.wannaread = wannaread
            s.recommend = recommend
            s.save
        rescue => exception
            puts "review is not found"
            return false
        end
    end

    def Delete(id)
        begin
            s = Detail.find(id)
            begin
                #レビュー更新
                book = Book.find(s.bookid)
                if (s.rating != 0)
                    if (book.ratingnumber == 1)
                        book.rating = 0
                        book.ratingnumber = 0
                    else
                        book.rating = (book.rating * book.ratingnumber - s.rating) / (book.ratingnumber - 1)
                        book.ratingnumber -= 1
                    end
                end
                book.wannanumber -= s.wannaread
                book.recommendnumber -= s.recommend
                book.save
            rescue => exception
                puts exception
                puts "this book is not found"                
                return 
            end
            s.destroy
        rescue => exception
            puts "review is not found"
        end
    end

    def Show
        @Review = Detail.all
        @Review.each do |a|
            puts a.bookid + "\t" + a.comment + "\t" + a.rating.to_s
        end
    end

    def GetReview(bookid)
        begin
            return Detail.where(bookid:bookid)
        rescue => exception
            return []
        end
    end

end