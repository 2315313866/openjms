#
# . include/deny_command.sh
# . include/menu.sh
# . var/data_hosts.sh
ssh_task() {

	local ssh_index="$1"
	local ssh_user="${2:-root}"
	eval "local ssh_port="\${inventory_host_${ssh_index}[port]}""
	local ssh_ip="${inventory_host[ssh_index]}"
	clear;
	ssh ${ssh_user}@${ssh_ip} -p ${ssh_port:-22}
}

menu_2() {
	local index=$1
	eval "local users=(\${inventory_host_${index}[login_user]})"
	
	# 当${users} 不为空时
	if [[ ! ${users} =~ ^( )*$ ]];then
		
		read_string_2="请输入需要登录的用户编号【quit切换上级菜单】："
		local menu_user="$(menu_host "${users[*]}" 70 "请选择登录用户")\n"
		
		while [[ true ]]; do
			clear;
			printf "$menu_user"
			read -e -p "${read_string_2}" read_user_index
			
			
			# 匹配数字或quit
			if [[  ${read_user_index} =~ ^([0-9]+|quit)$ ]]; then

				# 如果的数字数值不匹配则continue
				if (( read_user_index < ${#users[@]}  ));then
					# 条件都匹配，执行下面操作
					echo "${users[read_user_index]}"
					break;

				# 当接收数值为quit则退出上级菜单
				elif [[ ${read_user_index} == quit ]]; then
					clear;
					read_string_1="返回成功，请重新输入需要登录的主机【quit退出】："
					break;
				fi
			else
				read_string_2="错误请重新输入【quit切换上级菜单】："
				continue;
			fi

		done

		# work.sh里还有一层循环
		if [[ ${read_user_index} == quit ]]; then
			continue;
		fi
	else
		echo "root";
	fi
}


