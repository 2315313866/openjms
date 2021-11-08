#!/usr/bin/bash

# 进入工作目录
dir_path=${0}
if [[  "${0}" != "${dir_path##*/}" ]]; then
	cd ${dir_path%/*}/..
else
	cd ..
fi
pwd

# 调用函数和变量文件
. include/menu.sh
. include/thread_task.sh
. include/ssh_task.sh
. include/deny_command.sh
. include/read_content_check.sh
. var/data_hosts.sh
. var/data_conf.sh
#. include/main.sh


read_string_1="$(printf "Welcome to OpenJMS\n请输入主机编号[quit]: ")"

trap "" HUP INT TSTP
while [[ true ]]; do

		# 打印菜单栏
		clear;
		printf "$menu_1"
		read -e -p "${read_string_1}" host_index
		read_string_1="抱歉! 请输入正确的主机编号[quit]: "

		# 检查输入的内容是否匹配（如果不匹配函数内部会直接continue）
		read_content_check "${host_index}"

		# 打印用户2级菜单，(用户需要在配置文件中配置，如果没有配置则不会打印menu_2菜单，直接以root身份登录)
		menu_2 ${host_index}


		# 拒绝指定命令
		deny_cmd ${host_index}  ${ssh_user_name:-root}

		# 登录指定主机
		ssh_task ${host_index}  ${ssh_user_name:-root}

		# 退出后将禁用的命令允许
		allow_cmd ${host_index}  ${ssh_user_name:-root}
		read_string_1="退出成功，是否继续登录其他主机？[quit退出堡垒机]: "

done


