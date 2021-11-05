
# . include/menu.sh
# . include/thread_task.sh
# . include/ssh_task.sh
# . include/deny_command.sh
# . include/read_content_check
# . var/data_hosts.sh

# 拒绝命令
deny_cmd() {
	local deny_index=$1
	local deny_user=$2
	eval  "local deny_arr=(\${inventory_host_${deny_index}[deny_command]})"
	if [[ -n ${deny_arr} && ${deny_user} != root ]]; then
		
		local deny_ipaddr=${inventory_host[deny_index]}
		eval "local deny_port="\${inventory_host_${deny_index}[port]}""
		ssh root@${deny_ipaddr} -p ${deny_port:-22} "setfacl -m u:${deny_user}:r ${deny_arr[*]}"
	fi
	
}

# 允许命令
allow_cmd() {

	local allow_index=$1
	local allow_user=$2
	eval  "local allow_arr=(\${inventory_host_${allow_index}[deny_command]})"
	if [[ -n ${allow_arr} || ${allow_user} != root ]]; then
		
		local allow_ipaddr=${inventory_host[allow_index]}
		eval "local allow_port="\${inventory_host_${allow_index}[port]}""
		
		ssh root@${allow_ipaddr} -p ${allow_port:-22} "setfacl -m u:${allow_user}:r-x ${allow_arr[*]}"
	fi
}


# 通过修改命令权限进行拒绝
#	setfacl -m u:aa:r-x /usr/bin/touch
#	setfacl -m u:aa:r /usr/bin/touch