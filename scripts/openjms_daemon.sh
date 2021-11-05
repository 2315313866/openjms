#!/usr/bin/bash
. include/menu.sh
. include/thread_task.sh
. scripts/data_array.sh
. var/data_conf.sh


jms_daemon_pid="/var/run/openjms.pid"

echo "$$" > ${jms_daemon_pid}

# 防止将保准输出和错误输出打印到屏幕
exec 1<&-
exec 2<&-


# 每30秒探测一遍主机存活，并生成响应的数据
while [[ ture ]]; do
	sleep 30;

	data_array;
done