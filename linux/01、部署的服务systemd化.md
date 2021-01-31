
>**使用systemd的好处**
+ Systemd 统一管理所有 Unit 的启动日志。带来的好处就是，只用journalctl一个命令，查看所有日日志
用&和nohup非常不靠谱的。
+ Systemd Service 是一种替代/etc/init.d/下脚本的更好方式，它可以灵活的控制你什么时候要启动服务，一般情况下也不会造成系统无法启动进入紧急模式。所以如果想设置一些开机启动的东西，可以试着写 Systemd Service。
+ 可以设置服务启动的先后顺序

参考：http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-part-two.html  



> 脚本核心位于 [Service] 段，首先使用 Type 指令确定服务类型。simple（默认值）：  
ExecStart字段启动的进程为主进程  
指定服务的启动路径WorkingDirectory=/app/newgetui/gtcron


> **永久执行,**
```
sshd的配置文件：
执行的命令是/usr/sbin/sshd -D $OPTIONS，其中的变量$OPTIONS就来自EnvironmentFile字段指定的环境参数文件。 
simple的type与fork的type的异同点：

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ MAINPID是服务的systemd变量，它指向主应用程序的PID。

cat /usr/lib/systemd/system/sshd.service
[Unit]
Description= gtcron server daemon
After=network.target sshd-keygen.service


[Service]
EnvironmentFile=/etc/sysconfig/sshd
ExecStart=/usr/sbin/sshd -D $OPTIONS
ExecReload=/bin/kill -HUP $MAINPID
Type=simple
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.targe

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```
nginx的systemd配置文件

```$ cat /usr/lib/systemd/system/nginx.service

[Unit]
Description=The nginx HTTP and reverse proxy server
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/run/nginx.pid    # 路径和nginx.conf中保持一致
ExecStartPre=/usr/bin/rm -f /run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGQUIT
TimeoutStopSec=5
KillMode=process
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```
自写的服务配置systemd启动
```
[Unit]
Description=gtcron agent daemon
After=network.target sshd-keygen.service

[Service]
Type=simple
WorkingDirectory=/app/newgetui/gtcron
ExecStart=/app/newgetui/gtcron/gtcron_wroker
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target
```

> **一次执行,用作开启自启动**  
+ oneshot：适用于那些被**一次性执行的任务或者命令**，它运行完成后便了无痕迹。因为这类服务运行完就没有任何痕迹，我们经常会需要使用 RemainAfterExit=yes。意思是说，即使没有进程存在，Systemd 也认为该服务启动成功了。同时只有这种类型支持多条命令，命令之间用;分割，如需换行可以用\。  
eg：设置nfs挂载
```
cat /usr/lib/systemd/system/mount-nfs.service
[Unit]
Description=mount nfs 

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/mount -t nfs 192.168.16.168:/nfs /app/nfs -o nolock
ExecReload=/usr/bin/echo 'please'
ExecStop=/usr/bin/echo 'please'
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Run 'systemctl daemon-reload' to reload units.```

```
一次执行的例子:
gtcron.service has more than one ExecStart= setting, which is only allowed for Type=oneshot
只有在一次执行的时候才可以指定多个execstart
比如指定挂载等:

如果配置需要指定一个配置文件但是，systemd不支持使用配置文件如何做
```
cat /usr/lib/systemd/system/test.service
[Unit]
Description=test

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/mkdir /tmp/h1
ExecReload=/usr/bin/echo reload
ExecStop=/usr/bin/echo stop'

[Install]
WantedBy=multi-user.target
```

> **修改systemd的日志输出**  
+ 日志是放在/var/log/message中的，如果日志输出太多会打满，journalctl -u gtcron      
+ 试图使用如下命令将systemd服务的输出重定向到文件,但它似乎不起作用：    
StandardOutput=/app/newgetui/gtcron/boot.log  
此文件需要手工创建好  
+ 有一种更优雅的方法来解决问题：使用标识符将stdout / stderr发送到syslog,并指示您的syslog管理器按程序名称拆分其输出.
```
在systemd服务单元文件中使用以下属性：
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=gtcron
然后,假设您的发行版使用rsyslog来管理syslogs,创建/etc/rsyslog.d/gtcron.conf

if $programname == 'gtcron' then /app/newgetui/gtcron/boot.log
& stop
现在使syslog可以写入日志文件：
chown syslog:adm /path/to/log/file.log

sudo systemctl restart rsyslog
stdout / stderr仍然可以通过journalctl(sudo journalctl -u)获得,但它们也可以在您选择的文件中使用.

然后重启gtcron，另外创建改程序的启动日志
touch /app/newgetui/gtcron/boot.log
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```
