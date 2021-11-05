#!/usr/bin/bash
. var/data_conf.sh
. var/data_hosts.sh


jms_key="`cat  /root/.ssh/id_rsa.pub`"
for login_user in ${manager_user} ; do

	# 如果等于up说明该机器up状态
	for (( i = 0; i < ${#foreach_check_host_return[@]}; i++ )); do
		if [[ "${foreach_check_host_return[i]}" == "up" ]]; then
			
			eval "push_port="\${inventory_host_${i}[port]}""
			# 创建用户，并推送公钥,如果失败，说明之前该用户创建过，则退出
			timeout 3 ssh root@${inventory_host[i]} -p ${push_port:-22} "useradd ${login_user} >& /dev/null && mkdir -p /home/${login_user}/.ssh && echo "${jms_key}" >> /home/${login_user}/.ssh/authorized_keys"
			if [[ $? -eq 124 ]]; then
				echo "ssh root@${inventory_host[i]} timeout ，请检查一下" >> ./openjms.log
			fi
		fi
	done
done
