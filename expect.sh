#!/usr/bin/expect
# 支持lrzsz处理

set user [lindex $argv 0]
set ip [lindex $argv 1]
set port [lindex $argv 2]
set password [lindex $argv 3]
set home [lindex $argv 4]
set timeout 60

if { [regexp -nocase "/" $password] } {
	spawn ssh -o ServerAliveInterval=60 -p ${port} -i ${password} ${user}@${ip}
} else {
	spawn ssh -o ServerAliveInterval=60 -p ${port} ${user}@${ip}
}

# 判断条件，发送交互数据,
expect {
	timeout {puts "timeout"; exit}
	"*yes/no"	{send "yes\r"; exp_continue}
	"*password:" {send "${password}\r"; exp_continue}
	# export LC_CTYPE='' 自定义命令 防止中文出现乱码
	"*${user}@" {send "export LC_CTYPE='' \r"}
}

# 启用交互
interact
