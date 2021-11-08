
jms_daemon_pid_file="/var/run/openjms.pid"

if [[ -f ${jms_daemon_pid_file} ]]; then
    jms_daemon_pid="$(cat ${jms_daemon_pid_file})"
fi

work_task_script="$(pwd)/scripts/work.sh"

start() {

     # 检查jms_daemon是否运行
     if [[ -f ${jms_daemon_pid_file} ]]; then
          echo -e "\033[31mopenjms is running,[PID]=${jms_daemon_pid}\033[0m"
          exit;
     fi
     # 检查配置文件语法
     check_conf;

     # 初始化数据
     /usr/bin/cp  conf.d/openjms.conf var/data_conf.sh

     # 数据初始化完成后批量创建用户
     { data_array reload && bash scripts/push_login_user.sh;  }&
     sed -i '/scripts\/work\.sh/d' /root/.bashrc
     # 如果
     echo "bash ${work_task_script}" >> /root/.bashrc
     
     
     # 启动配置jms_daemon
     nohup bash scripts/openjms_daemon.sh >/dev/null 2>&1 &
     echo -e "\033[32mopenjms running successful\033[0m"
}

stop() {
     # 检查jms_daemon是否运行
     if [[ ! -f ${jms_daemon_pid_file} ]]; then
          echo -e "\033[32mopenjms already stop\033[0m"
          exit;
     fi

     # 清理数据
     sed -i '/scripts\/work\.sh/d' /root/.bashrc
     kill -9 ${jms_daemon_pid} && rm -f ${jms_daemon_pid_file}
     echo -e "\033[32mopenjms stop successful\033[0m"
}

reload () {
     # 检查配置文件语法,检查语法模块暂未编写
     check_conf;

     # 重载数据
     /usr/bin/cp  conf.d/openjms.conf var/data_conf.sh
        
     { data_array reload && bash scripts/push_login_user.sh;  }&
}

status() {
     # 检查jms_daemon是否运行
     if [[ -f ${jms_daemon_pid_file} ]]; then
          echo -e "\033[32mopenjms is running,[PID]=${jms_daemon_pid}\033[0m"
          exit;
     fi
     echo -e "\033[32mopenjms is stop\033[0m"
     exit;
}
