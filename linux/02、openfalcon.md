
# openfalcon使用

## 1、进程监控
> 进程监控和端口监控类似，也是通过用户配置的策略自动计算出来要采集哪个进程的信息然后上报
proc.num/name=ntpd if all(#2) == 0 then alarm()
proc.num/cmdline=uic.properties if all(#2) == 0 then alarm()

cmdline的作用
>cmdline，name是从/proc/$pid/status文件采集的，cmdline是从/proc/$pid/cmdline采集的。这个文件存放的是你启动进程的时候用到的命令，比如你用java -c uic.properties启动了一个Java进程，进程名是java，其实所有的java进程，进程名都是java，那我们是没法通过name字段做区分的。怎么办呢？此时就要求助于这个/proc/$pid/cmdline文件的内容了
但是cmdline不是，我们只需要拷贝cmdline的一部分字符串，能够与其他进程区分开即可

```
生产环境使用例子：
proc.num/cmdline=plat_nginx_template [dsp的的nginx consul-templat进程挂了!!!]
proc.num/cmdline=dmp_nginx_template [dsp-gateway的nginx consul-template进程挂了!!!]

```
