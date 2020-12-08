require 'digest/md5'
require 'active_record'
require 'time'

ActiveRecord::Base.configurations = YAML.load_file('./database/database.yml')
ActiveRecord::Base.establish_connection :development

class Account < ActiveRecord::Base
end
class Detail < ActiveRecord::Base
end
class Passwd

    def initialize
        @r = Random.new
        
    end

    def GenAccount(username, rawpasswd, algorithm)
        salt = Digest::MD5.hexdigest(@r.bytes(20))
        hashed = Digest::MD5.hexdigest(salt + rawpasswd)
        puts "username = #{username}"
        puts "ras passwd = #{rawpasswd}"
        begin
            s = Account.new
            s.id = username
            s.salt = salt
            s.hashed = hashed
            s.algo = algorithm
            s.date = "-1"
            s.save
        rescue => e
            puts "That user name is already registered"
        end
    end

    def CheckAccount(username, passwd)
        puts "username = #{username}"
        puts "passwd = #{passwd}"
        begin
            a = Account.find(username)
            db_username = a.id
            db_salt = a.salt
            db_hashed = a.hashed
            db_algo = a.algo
            db_date = a.date
        rescue => e
            puts "user #{username} is not found."
        end
        #ハッシュアルゴリズムが1であれば
        if db_algo == "1"
            trial_hashed = Digest::MD5.hexdigest(db_salt + passwd)
        else 
            puts "Unkown algorithm is used for user #{username}."
            return
        end

        #Success?
        if db_hashed == trial_hashed
            puts "login success"
            a = Account.find(username)
            if a.date.to_i == -1
                puts "first login"
            else
                puts "last:#{Time.at(a.date.to_i).strftime("%Y年 %m月 %d日 %H時 %M分 %S秒")}"
            end
            a.date = Time.now.to_i
            a.save
            
        else 
            puts "login failed"
        end

    end

    def DelAccount(username)
        puts "username = #{username}"
        begin
            a = Account.find(username)
            #該当レビューを消す
            begin
                reviews = Detail.where(name:username)
                reviews.each do |s|
                    s.destroy
                end
            rescue => exception
                return
            end
            a.destroy
        rescue => e
            puts "user #{username} is not found."
        end

    end

    def ShowAccount
        @s = Account.all
        @s.each do |a|
            puts a.id + "\t" + a.salt + "\t" + a.hashed + "\t" + a.algo
        end
    end

end




