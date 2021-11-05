#######################################
 # 函数说明：功能函数，多线程执行传入的回调函数任务
 # 未决问题：未知
 # 全局变量：无
 # 函数示例：thread_task 10 "{data_array[*]}" callback
 # Arguments:
 #   $1 : 控制线程的最大并发数(int)
 #   $2 : 操作的数据数组(array)
 #   $3 : 线程中执行具体任务的回调函数(function)
 # return：返回数组，需要用数组接收
 # author: Shuilong Shen <2315313866@qq.com>
 #######################################
thread_task() {

	# $2 数组中如果有元素包含空格可能无法被函数内部正常识别
	local thread_num=$1 
	local task_array=($2)
	local callback=$3
	local task_array_len=${#task_array[@]}
	local control_fd=3
	local task_fd_begin=300
	local control_fifo_path=/tmp/jumpserver.fd1
	
	[ -e ${control_fifo_path} ]  || mkfifo ${control_fifo_path}
	eval "exec ${control_fd}<>${control_fifo_path}" && rm -rf ${control_fifo_path}

	# 控制线程的最大并发为thread_num
	for (( i = 0 ; i < thread_num; i++ )); do

		# 每循环一次,写入一个\n到${control_fd} 文件描述符里
		echo >&${control_fd}
	done

	# 调用线程处理回调函数任务
	for (( i = 0; i < task_array_len; i++ )); do
		
		# 每次都会创建一个管道和文件描述符，用于实现子进程和父进程的数据通信(shell里面并没有线程一说，抽象理解为线程吧)
		local task_fd=$[ task_fd_begin + i ]
		local task_fd_path="${control_fifo_path}_task_fd${task_fd}"

		[ -e ${task_fd_path} ]  || mkfifo ${task_fd_path}
		eval "exec ${task_fd}<>${task_fd_path} && rm -rf ${task_fd_path}"
		
		# 每读取到\n,就继续下面任务，若${control_fd}里面没有数据，则阻塞等待
		read -u${control_fd}
		{
			
			# ${callback} 是$3传递过来的，用于处理任务的函数名，然后将结果赋值给${task_end}
			task_end="$(eval ${callback} ${task_array[i]})"

			# 下面会用read读取${task_fd}传递的数据，需要将read的读取分隔符从'\n'改为我们自定义的'EOF'，因为${task_end} 可能包含'\n'防止冲突
			printf "${task_end}"'EOF' >&${task_fd}

			# 任务处理完成后，通知控制线程(往${control_fd}里输出一个\n)
			echo >&${control_fd} 
		}&
	done
	# 阻塞等待task全部执行完成
	wait
	# 当所有线程完成工作后，遍历每个task数据，然后销毁fd
	for (( i = 0; i < task_array_len; i++ )); do
		# 赋值当前task的fd
		task_fd=$[ task_fd_begin + i ]

		# 读取当前fd的数据，当碰到'EOF'结束读取，并赋值给task_gather
		read -r -d 'EOF' -u${task_fd} task_gather

		# 将读取到的数据赋值给数组
		task_array[i]="${task_gather}\n"

		# 读取完成后，销毁当前遍历的fd
		eval "exec ${task_fd}<&-"
		eval "exec ${task_fd}>&-"
	done

	# 任务fd销毁后，然后销毁控制线程 fd
	eval "exec ${control_fd}<&-"
	eval "exec ${control_fd}>&-"

	# 最后将数组返回
	echo -en "${task_array[@]}"
}

