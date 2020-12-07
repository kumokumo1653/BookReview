require './database/pass'

pass = Passwd.new

pass.ShowAccount()
puts ""
pass.CheckAccount("nobunaga","achichi-achichi")
puts ""
pass.GenAccount("singen","yamai-yamai",1)
puts ""
pass.CheckAccount("singen","yamai-yamai")
puts ""
pass.DelAccount("singen");
puts ""
pass.ShowAccount()
pass.CheckAccount("singen","yamai-yamai")