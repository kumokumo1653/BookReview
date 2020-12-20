require 'digest/md5'
require 'active_record'

ActiveRecord::Base.configurations = YAML.load_file('./database/database.yml')
ActiveRecord::Base.establish_connection :development

USERNAME = 15
PASSWD = 100
class Account < ActiveRecord::Base
end
class Detail < ActiveRecord::Base
end
class Book < ActiveRecord::Base
end
class User

    def initialize
        @r = Random.new
    end

    def GenAccount(username, rawpasswd, algorithm)
        salt = Digest::MD5.hexdigest(@r.bytes(20))
        hashed = Digest::MD5.hexdigest(salt + rawpasswd)
        if(username.length > USERNAME)
            return false
        end
        if(!(username =~ /\A[a-z\d]+\z/i))
            return false
        end
        if(rawpasswd.length > PASSWD)
            return false
        end
        if(!(rawpasswd =~ /\A[a-z\d]+\z/i))
            return false
        end
        begin
            s = Account.new
            s.id = username
            s.salt = salt
            s.hashed = hashed
            s.algo = algorithm
            s.save
        rescue => e
            puts "That user name is already registered"
            return false
        end
        return true
    end

    def CheckAccount(username, passwd)
        puts "username = #{username}"
        puts "passwd = #{passwd}"
        if(username.length > USERNAME)
            return false
        end
        if(!(username =~ /\A[a-z\d]+\z/i))
            return false
        end
        if(passwd.length > PASSWD)
            return false
        end
        if(!(passwd =~ /\A[a-z\d]+\z/i))
            return false
        end
        begin
            a = Account.find(username)
            db_username = a.id
            db_salt = a.salt
            db_hashed = a.hashed
            db_algo = a.algo
        rescue => e
            puts "user #{username} is not found."
            return false
        end
        #ハッシュアルゴリズムが1であれば
        if db_algo == "1"
            trial_hashed = Digest::MD5.hexdigest(db_salt + passwd)
        else 
            puts "Unkown algorithm is used for user #{username}."
            return false
        end

        #Success?
        if db_hashed == trial_hashed
            return true
        else 
            puts "login failed"
            return false
        end

    end

    def DelAccount(username)
        puts "username = #{username}"
        begin
            a = Account.find(username)
            #該当レビューを消す
            begin
                reviews = Detail.where(name:username)
                #本のレビューの更新
                reviews.each do |s|
                    book = Book.find(s.bookid)
                    if (s.rating != 0)
                        if (book.ratingnumber <= 1)
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
                    s.destroy
                end
            rescue => exception
                puts exception
                return false
            end
            a.destroy
        rescue => e
            puts "user #{username} is not found."
            return false
        end
        return true
    end

    def ShowAccount
        @s = Account.all
        @s.each do |a|
            puts a.id + "\t" + a.salt + "\t" + a.hashed + "\t" + a.algo
        end
    end

end




