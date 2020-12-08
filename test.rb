require './database/pass'
require './database/book'
require './database/review'

pass = Passwd.new
lib = Library.new
review = Reviewer.new

pass.GenAccount("singen","yamai-yamai",1)
puts ""
pass.CheckAccount("singen","yamai-yamai")
puts ""

pass.GenAccount("nobunaga","achichi-achihi",1)
puts ""
pass.CheckAccount("nobunaga","achichi-achihi")
puts ""

lib.Register("0001", "ハリーポッタ", "J.Kローリン", 500, "2020-01", "小学館", "あらすじ")
lib.Show
puts ""

review.Add("0001", "singen", 3, "感動しました",0,1)
review.Add("0001", "nobunaga", 4, "感動しました", 0, 0)
review.Show

lib.Show
puts ""
review.Change("0001singen", 0, "", 0 , 0)
review.Show
lib.Show
puts ""

puts "asdf"
