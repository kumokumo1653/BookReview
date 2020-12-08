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

lib.Register("0001", "ハリーポッタ", "J.Kローリン", 500, "2020-01", "小学館", "あらすじ")
lib.Show
puts ""

review.Add("0001", "singen", 3, "感動しました")
review.Show
puts ""

lib.Delete("0001")
lib.Show
puts ""

pass.DelAccount("singen")
puts "asdf"
