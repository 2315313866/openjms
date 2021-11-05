########################################
 # 函数说明：功能函数，打印主机菜单、菜单栏，标题自动居中，自动生成
 # 未决问题：标题若包含英文则生成菜单有瑕疵，但不明显
 # 全局变量：无
 # 函数示例：thread_task "{host_array[*]}" 70 "开源堡垒机" 0
 # Arguments:
 #   $1 : 菜单栏清单数组(array)
 #   $2 : 菜单宽度(int)
 #   $3 : 菜单标题(string)
 #   $4 : 数据偏移量(int,常规情况下0);+4或者-4 
 # 输出： 输出到STDOUT
 # author: Shuilong Shen <2315313866@qq.com>
 #######################################
menu_host() {
	# 定义主机数据
		local Host=($1)
		# 定义列长度
		local menu_lie=$2
		# 定义行长度
		local menu_host=${#Host[@]}
		local menu_hang=$[ menu_host + 2 ]
		# 定义标题居中相关变量
		local host_name="$3"
		local Host_name_len=$[ ${#host_name} * 2 ]
		local Host_name_len_begin=$[ ($menu_lie - $Host_name_len) / 2 ]
		local Host_name_len_end=$[ Host_name_len_begin + Host_name_len -1 ]

	# 定义结尾列偏移量
	local menu_offset=$4
	# 外循环控制行
	for (( hang = 1; hang <= menu_hang; hang++ )); do
		
		# 当第一行或最后一行
		if [[ ${hang} -eq 1 ||  ${hang} -eq ${menu_hang}  ]]; then
		
			# 内循环控制列
			for (( lie = 1; lie <= menu_lie; lie++ )); do
				# 进来后说明${hang}为1或最后一行，这时判断${lie}是否为1或者最后一列
				if [[ ${lie} -eq 1 || ${lie} -eq ${menu_lie} ]]; then
					# 如果条件匹配则输出+号不换行，并跳出当次循环
					printf "+";
					continue;
				fi

				# 当为${hang}为1且列为${Host_name_len_begin}时，插入${host_name}
				if [[  ${hang} -eq 1 && ${lie} -eq ${Host_name_len_begin}  ]]; then
					printf "${host_name}"
					# 插入完${host_name}后，需要重新定义lie的长度：begin开始长度 + ${host_name}长度
					lie=${Host_name_len_end}	# 功能：实现标题居中
					continue;
				fi

				# 条不符合则打印 "-"
				printf "-";
			done
			#每行结束后都打印一遍换行符
			echo -n "\n";

			# 如果if进来则说明是第一行或最后一行，则不用执行下面的所有操作，跳出外循环
			continue;
		fi



		# 中间循环打印主机清单数组
		# 由于外循环${hang}初始值为1，且第1行不打印主机清单，则需要${hang} - 2将index初始值为0
		local index=$[ ${hang} - 2 ]
			# 这里计算Host数组中每个元素的长度并+" ${index}) "的长度
			local Host_len=$[ ${#Host[index]}  + 4 + ${#index} ]
			# 用总长度 - Host_len = 空格填充次数 	 # (menu_offset) 用小括号包裹提高优先运算防止出现(+2)或(-2)
			local old_len=$[ menu_lie - Host_len + (menu_offset)  ] # 有时Houst_len长度引用特殊符号可能造成长度不准确，需要使用menu_offset调整偏移量
			# old_len=$[ menu_lie - Host_len  ]
			# 打印既定的每个ip地址，然后不换行，后面用空格填充${old_len}次数后用|结尾并换行
			printf "| ${index}) ${Host[index]}";

		# 中间行输出主机信息
		for (( lie = 1; lie <= old_len ; lie++ )); do
			
			# 判断${lie}为最后一列时需要用"|"结尾并换行
			if [[ ${lie} -eq old_len ]]; then

				# 第2行打印附加信息
				if [[ ${hang} -eq 2 ]]; then
					echo -n "|\n";
					continue;
				fi

				echo -n "|\n";
				continue;
			fi
			# 填充空格
			printf " ";
		done
	done
}




