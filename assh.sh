#!/bin/bash

declare -i i=0
export LC_CTYPE=en_US

# 脚本路径
scripts_dir="/Users/$(whoami)/Documents/assh"

# 用户密码清单路径
authfile_file_path="${scripts_dir}/authfile"
# 主机清单文件路径
inventory_file_path="${scripts_dir}/hosts"
# expect文件路径
expect_file_path="${scripts_dir}/expect.sh"

# 链接编号
parameter_num=$1

function help(){
  # 直接链接：打印主机列表
	echo "01). Serial number | example: assh"
	# 通过主机编号进行链接：assh 编号
	echo "02). Serial number for command | example: assh 0"
	# 链接自定义主机：通过自定义账号密码
	echo "03). -o | example: assh -o username@host_address -p host_password"
	# 链接自定义主机：通过本机存储的用户密码链接
	echo "04). -o | example: assh -o username@host_address (User white list needs to be configured)"
	exit 137
}

if [[ $parameter_num =~ 'help' ]];then help;fi

echo "=================主机快捷管理=============="
while read line
do
	host_tags=`echo ${line}|grep 'ansible_ssh_user'|awk -F = '{print $5}'`
	if [[ ${line} == "" || $host_tags == "" || ${line} =~ ^"[" ]]; then
		continue
	fi
	user_info=`echo ${line}|grep 'ansible_ssh_user'|awk -F = '{print $2,$3}'|awk '{print $1echo ":" $3}'`
	connection=`echo ${line}|grep 'ansible_ssh_user'|awk -F = '{print $1,$4}'|awk '{print $1echo ":" $3}'|cut -d'#' -f2`
	user[$i]=`echo ${user_info} | cut -d ":" -f 1`
	password[$i]=`echo ${user_info} | cut -d ":" -f 2`
	address=`echo ${connection} | cut -d "/" -f 1`
	ip[$i]=`echo ${address} | cut -d ":" -f 1`
	port[$i]=`echo ${address} | cut -d ":" -f 2`
	tags[$i]=`echo ${host_tags}`

	if [[ ${ip[$i]} == ${port[$i]} ]]; then
		port[$i]=22
	fi

	echo $i: ${tags[$i]}
	
	i+=1
done < ${inventory_file_path}

echo "==========================================="


# Support command line input parameters
if [[ $parameter_num != '' ]]; then
	if [[ $parameter_num == '-o' ]];then
	username=`echo $2|cut -d'@' -f1`
	hostaddr=`echo $2|cut -d'@' -f2`
	password=`echo $4|cut -d'@' -f6`
	if [[ $username == $(cat ${authfile_file_path}|grep $username|cut -d':' -f1) ]];then
	password=$(cat ${authfile_file_path}|grep $username|cut -d':' -f2);exec ${expect_file_path} $username $hostaddr 22 $password ~
	fi
	if [[ $password == '' ]];then echo "You must enter a password for $hostaddr.";exit 137;fi
	exec ${expect_file_path} $username $hostaddr 22 $password ~
	else num=$parameter_num;fi
else
	read -p "Enter serial number connection(0): " -t 10 num
	if [[ $? != 0 ]]; then
		echo -e "\nInput timeout;Auto exited."
		exit 1
	fi
fi
clear
exec ${expect_file_path} ${user[${num}]} ${ip[${num}]} ${port[${num}]} ${password[${num}]} ${home[${num}]}
