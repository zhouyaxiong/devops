## 监控思路

+ 不同的kafa集群，数据存入不同的database数据库
+ jmxtrans我们可以分别在每台kafka节点上部署，也可以部署到一台机器上，我这里是选择了后者，因为我的集群小，这样配置文件可以集中管理
+ influxdb的默认保存时间是168h，7天

```
监控80个jvm数据情况下  pidstat的资源使用情况
cpu使用情况：当前使用的是7号cpu
pidstat -u -p 23862 2
Linux 3.10.0-123.el7.x86_64 (HZ-E04-05-sa.getui)        02/09/2021      _x86_64_        (24 CPU)
02:15:07 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
02:15:09 PM   989     23862    0.00    0.00    0.00    0.00     7  wrapper-linux-x
02:15:11 PM   989     23862    0.00    0.00    0.00    0.00     7  wrapper-linux-x

内存使用情况
pidstat -r -p 23862 2  2
Linux 3.10.0-123.el7.x86_64 (HZ-E04-05-sa.getui)        02/09/2021      _x86_64_        (24 CPU)

02:15:34 PM   UID       PID  minflt/s  majflt/s     VSZ    RSS   %MEM  Command
02:15:36 PM   989     23862      0.00      0.00   17812    776   0.00  wrapper-linux-x
02:15:38 PM   989     23862      0.00      0.00   17812    776   0.00  wrapper-linux-x

```

## 安装jmxtrans
jmxtrans的作用是自动去jvm中获取所有jmx格式数据，并按照某种格式（json文件配置格式）输出到其他应用程序（本例中的influxDB）。

+ jmxtrans有配置文件变动会收集不到数据
+ 其配置文件分全局指标（每个kafka节点）和topic指标，
+ 全局指标每个节点一个配置文件，命名规则：base_10.10.20.14.json
+ topic指标是每个topic一个配置文件，命名规则：topic_172.30.4.60_9891.json

> 实际的场景中是只收集全局指标即可，**topic级别的指标可以不做收集**

```
从github中下载jmxtrans的安装包,最新的包是2012年的：
https://github.com/jmxtrans/jmxtrans/downloads

sudo yum install jmxtrans-20121016.145842.6a28c97fbb-0.noarch.rpm
jmxtrans安装目录：/usr/share/jmxtrans
jmxtrans配置文件 ：/etc/sysconfig/jmxtrans
json文件默认目录：/var/lib/jmxtrans/
日志路径：/var/log/jmxtrans/jmxtrans.log

启动和停止
sudo /usr/share/jmxtrans/jmxtrans.sh start
sudo /usr/share/jmxtrans/jmxtrans.sh stop





```


## 修改配置文件
+ 确保jmxtrans和kafka 的jmx端口可以正常通信
+ 确保jmxtrans和influxdb的网络状态正常
```

生成jmx的配置文件，放在/var/lib/jmxtrans/
先做一个主机的一个配置文件，之后进行copy
for i in  `seq 1 1 2`;do cp base_10.34.21.80_9091.json  base_10.16.21.80_909$i.json;done
sed替换变量的时候加单引号即可
修改同一个主机配置文件中的端口号
for i in  `seq 1 1 2`;do sed  -i 's#9091#989'$i'#g'  base_10.16.21.80_909$i.json;done

```








