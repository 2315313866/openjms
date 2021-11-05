declare -A inventory_host_0=([ipaddr]=172.16.1.6  	[port]=22	[deny_command]="/usr/bin/vim /usr/bin/touch")
declare -A inventory_host_1=([ipaddr]=172.16.1.8  	[port]=22	[deny_command]="/usr/bin/vim /usr/bin/touch")
declare -A inventory_host_2=([ipaddr]=172.16.1.4  	[port]=22	[deny_command]="/usr/bin/vim /usr/bin/touch")
declare -A inventory_host_3=([ipaddr]=172.16.1.7  	[login_user]="dev_1 ops_1" [deny_command]="/usr/bin/vim /usr/bin/touch")
declare -A inventory_host_4=([ipaddr]=172.16.1.9  	[login_user]="ops_1"     [deny_command]="/usr/bin/pwd")
declare -A inventory_host_5=([ipaddr]=172.16.1.3   	[deny_command]="/usr/bin/vim /usr/bin/touch")
declare -A inventory_host_6=([ipaddr]=172.16.1.62 	[deny_command]="dev_1 ops_1")
inventory_host_max=7
inventory_host=(172.16.1.6 172.16.1.8 172.16.1.4 172.16.1.7 172.16.1.9 172.16.1.3 172.16.1.62)
foreach_check_host_return=(up up down up up up up)
menu_1="+----------------------------开源堡垒机------------------------------+\n| 0) 172.16.1.6---->[[1;32;05mup[0m]                                             |\n| 1) 172.16.1.8---->[[1;32;05mup[0m]                                             |\n| 2) 172.16.1.4---->[[1;31;05mdown[0m]                                           |\n| 3) 172.16.1.7---->[[1;32;05mup[0m]                                             |\n| 4) 172.16.1.9---->[[1;32;05mup[0m]                                             |\n| 5) 172.16.1.3---->[[1;32;05mup[0m]                                             |\n| 6) 172.16.1.62---->[[1;32;05mup[0m]                                            |\n+--------------------------------------------------------------------+\n\n"
