## SSH管理工具

一个用于快速连接ssh的脚本工具

### 概述

使用本工具(assh):

1). 易用易维护   
2). 提高连接效率  
3). 可使用ansible控制

### 1.初始化

安装expect

```shell
MacOS
$ brew install expect

Linux
$ yum install expect
```

拉取代码

```shell
MacOS
$ git clone https://github.com/yaobohai/assh.git /Users/$(whoami)/Documents/assh

Linux
$ git clone https://github.com/yaobohai/assh.git /usr/local/assh/
```

更新主机清单

```shell
MacOS
$ vim /Users/$(whoami)/Documents/assh/hosts

Linux
$ vim /usr/local/assh/hosts
```

配置环境变量

```shell
MacOS
$ vim ~/.zshrc
alias assh='/Users/$(whoami)/Documents/assh/assh.sh'

Linux
$ vim ~/.bashrc
alias assh='/usr/local/assh/assh.sh'

配置完成后新打开终端配置生效
```

增加权限

```shell
MacOS
$ chmod +x /Users/$(whoami)/Documents/assh/*.sh

Linux
$ chmod +x /usr/local/assh/*.sh
```

### 2.交互式菜单

```shell
$ assh
=================主机快捷管理==============
0: node01
1: node02
2: node03
===========================================
Enter serial number connection(0):

## example: assh
```

### 3.命令行登陆(序号版)

```shell
$ assh 序号

## example: assh 0
```

### 与ansible搭配使用

脚本使用的hosts清单与ansible inventory一致。如果使用ansible控制主机，那么只需要指定主机清单位置即可：

```shell
$ vim /etc/ansible/ansible.cfg
[defaults]
inventory      = assh脚本路径/hosts
```

运行

```shell
#ansible -m ping 主机组名称

$ ansible -m ping demo
192.168.60.1 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
192.168.60.2 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
192.168.60.3 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
```
