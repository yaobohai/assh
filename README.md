## SSH管理工具

一个适用于MacOS的用于快速连接ssh的脚本工具

### 概述

使用本工具(assh):

1). 易用易维护   
2). 提高连接效率  
3). 可使用ansible控制

### 1.初始化

拉取代码

```shell
$ git clone https://github.com/yaobohai/assh.git /Users/$(whoami)/Documents/assh
```

更新主机清单

```shell
$ vim /Users/$(whoami)/Documents/assh/hosts
```

配置环境变量

```shell
$ vim ~/.zshrc
alias assh='/Users/$(whoami)/Documents/assh/assh.sh'
```
增加权限

```shell
chmod +x /Users/$(whoami)/Documents/assh/*.sh
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

### 4.命令行登陆(密码版)

```shell
$ assh -o 用户名@IP
或
$ assh -o 用户名@IP -p 密码

## example: assh -o root@116.63.254.156 (需配置用户白名单)
## example: assh -o root@116.63.254.156 -p asddaa...
```

注意: `.authfile` 文件为用户白名单配置;当使用 `-o` 参数连接主机时,输入的用户名被脚本匹配到则使用白名单里的配置；否则强制需要密码.

白名单配置格式:

```
用户名:密码
## example: appuser:12345678
```

### 与ansible搭配使用

脚本使用的hosts清单与ansible inventory一致。如果使用ansible控制主机，那么只需要指定主机清单位置即可：

```shell
$ vim /etc/ansible/ansible.cfg
[defaults]
inventory      = /Users/替换为你的用户名/Documents/assh/hosts
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

### 在Linux环境中使用

在Linux中使用该脚本 与macos没有太大区别，唯一需要注意的只是脚本位置以及expect命令

1、安装expect

```shell
$ yum -y install expect
```

2、更新脚本路径

```shell
sed -i 's/\/Users\/$(whoami)\/Documents\/assh/\/usr\/local\/assh/g' README.md
sed -i 's/\/Users\/替换为你的用户名\/Documents\/assh/\/usr\/local\/assh/g' README.md
sed -i 's/\/Users\/$(whoami)\/Documents\/assh/\/usr\/local\/assh/g' assh.sh
```

3、查看本机的README.md 进行使用