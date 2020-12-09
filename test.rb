require './database/user'
require './database/book'
require './database/review'

pass = User.new
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

pass.GenAccount("ieyasu","tanuki",1)
puts ""
pass.CheckAccount("ieyasu","tanuki")
puts ""

lib.Register("0001", "ハリーポッタ", "J.Kローリン", 500, "2020-01", "小学館", "あらすじ")
lib.Show
puts ""

review.Add("0001", "singen", 3, "感動しました",0,1)
review.Add("0001", "nobunaga", 4, "感動", 0, 0)
review.Add("0001", "ieyasu", 0, "", 1, 0)
review.Show

lib.Show
puts ""


review.Delete("0001nobunaga")
review.Show
lib.Show
puts "asdf"

review.Change("0001singen", 0, "", 0 , 0)
review.Show
lib.Show
puts ""
lib.Delete("0001")
review.Show
lib.Show
puts "asdf"

