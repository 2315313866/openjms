#-----------------------
# eval \${inventory_host_${index}}	# 关联数组,存放hosts文件中每条数据，[ipaddr],[port],[deny_command]
# ${inventory_host_max}				# 普通变量，记录了 \${inventory_host_${index}}的索引数量
# ${inventory_host} 				# 普通数组，存放hosts文件中所有的IP地址
# 
# menu_1_arr
#-----------------------

#. include/menu.sh
#. include/thread_task.sh
#. var/data_conf.sh

# 检查主机状态，并提供返回值，用户批量创建用户时down的ip不创建
check_host_return() {
	check_ip=$1
	ping -c1 -W1 ${check_ip} &> /dev/null
	if [[ $? -eq 0 ]]; then
		echo "up"
		return;
	fi
	echo "down"
}


data_array() {

	data_file=var/data_hosts.sh
	# 获取conf.d/hosts配置文件的ip 端口，和拒绝的相关命令
	if [[ "$1" == "reload" ]]; then
		
		# 清空之前数据
		echo -n "" > ${data_file}
		index=0;
		IFS=$'\n'
		for host in $(cat conf.d/hosts|egrep -v "^#|^$"); do
			# 定义关联数组，用于存放../conf.d/hosts配置文件里每条数据
			eval "declare -A inventory_host_${index}=(${host})"

			# 存入变量文件
			echo -n "declare -A inventory_host_${index}=(${host})" >> ${data_file}
			printf "\n" >> ${data_file}

			# 将所有host抽离出来，单独存放在inventory_host数组中
			eval "inventory_host[${index}]=\${inventory_host_${index}[ipaddr]}"
			((index++))
		done
		# 配置文件中定义的主机最大数
		inventory_host_max=${index}
		echo "inventory_host_max=${inventory_host_max}" >> ${data_file}
		
		# 将ip抽离为一个数组
		echo  "inventory_host=(${inventory_host[@]})" >> ${data_file}
	else
		sed -i '/^menu_1=/d'  ${data_file}
		sed -i '/^foreach_check_host_return=/d'  ${data_file}
		. ${data_file}
	fi



	# 获取所有ip地址的状态，用与检测和创建用户使用
	foreach_check_host_return=($(thread_task ${checking_forks} "${inventory_host[*]}" check_host_return))
	
	# up状态打印绿色，down状态打印红色
	foreach_check_host="";
	for (( i = 0; i < inventory_host_max ; i++ )); do
		if [[ "${foreach_check_host_return[i]}" =~ "up" ]]; then
			foreach_check_host[i]="${inventory_host[i]}---->[\e[1;32;05mup\e[0m]"

		else
			foreach_check_host[i]="${inventory_host[i]}---->[\e[1;31;05mdown\e[0m]"
		fi
	done
	
	menu_1="$(menu_host "${foreach_check_host[*]}"  70 ${jms_name} +16)\n"

	# 存入data.sh 文件后续直接调用改文件
	echo "foreach_check_host_return=(${foreach_check_host_return[@]})" >> ${data_file}

	
	echo -n "menu_1=\"${menu_1}\"" >> ${data_file}
	printf "\n" >> ${data_file}
}


