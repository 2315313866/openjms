# . var/data_conf.sh
# . var/data_hosts.sh
read_content_check() {
	local content="$1"
		# 判断如果不是既定的字符串则continue
	if [[ ! ${content} =~ ^([0-9]+|${super_pass}|quit)$ ]]; then
		continue;
	fi

	# 当接收数值为ssl则退出
	if [[ ${content} == ${super_pass} ]]; then
		clear;
		echo -e "\e[1;33;05m您已进入堡垒机系统内部，请谨慎操作!!!\e[0m" 
		exit;
	fi


	if [[ ${content} == quit ]]; then

		read_string_1="`printf "抱歉，quit退出终端暂未修订,谁会帮忙补齐一下\n请登录其他机器："`"
		continue;
	fi


	# 检查用户输入的IP地址是否能ping通，不通则直接打印出来
	if (( content >= inventory_host_max ))  ; then
		continue;
	fi

	if [[ ${foreach_check_host_return[content]} == "down" ]]; then
		read_string_1="$( printf "抱歉! ${inventory_host[content]} 的状态为[\e[1;31;05mdown\e[0m] 因此无法登入\n请登录其他机器或者quit退出：")"
		continue;
	fi
}