# alertmanager--告警多了就是反模式
> grafana告警的缺点：  
老实说grafana告警不是很好用，也不能分级告警，容易产生告警风暴   
Grafana 的报警功能，但是 Grafana 的报警功能目前还比较弱，只支持 Graph 的图表的报警，使用prometheus-alertmanager替代grafana上的告警


> Prometheus Alertmanager的优势(见语雀和prometheus书)：  
    防止告警风暴，达到告警收敛目的  
    设置时间段，对接收到的同类告警只发送一条  
    系统出问题同类告警只发送一条  
    配置文件配置  
    告警聚合将多条告警发送到一封邮件或者微信消息中


说明：  
prometheus-operator部署alert-manager使用有状态的方式进行部署，  
alertmanger有专门的页面，
此pod使用nodepod的方式暴露即可：service/alertmanager-main  




```
AlertManager的三个概念
分组：Grouping 是 Alertmanager 把同类型的警报进行分组，合并多条警报到一个通知中
抑制：Inhibition 是 当某条警报已经发送，停止重复发送其引发的其他高级
静默：Silences 提供了一个简单的机制，根据标签快速对警报进行静默处理；对传进来的警报进行匹配检查，如果接受到警报符合静默的配置，Alertmanager 则不会发送警报通知。

```

生产中的建议：  
+ 将多个集群的prometheus联邦起来，再统一使用alertmanager进行告警，告警方式只在一台上面配置即可
+ 在Alertmanager中可以使用如下配置定义基于webhook的告警接收器receiver。一个receiver可以对应一组webhook配置。  
+  

```
prometheus自带的监控项说明：
alertmanager集群一半覆灭
 (count by(namespace, service) (avg_over_time(up{job="alertmanager-main",namespace="monitoring"}[5m]) < 0.5) [定义出分子]/ count by(namespace, service) (up{job="alertmanager-main",namespace="monitoring"})) >= 0.5

description: '{{ $value | humanizePercentage }} of Alertmanager instances within the {{$labels.job}} cluster have been up for less than half of the last 5m.'


up输出在用的，avg_over_time取一段时间的均值
process_start_time_seconds，输出的是pod的创建时间，这个时间是不会变的

alertmanager集群崩溃
 (count by(namespace, service) (changes(process_start_time_seconds{job="alertmanager-main",namespace="monitoring"}[10m]) > 4) / count by(namespace, service) (up{job="alertmanager-main",namespace="monitoring"})) >= 0.5

description：
先找出10分钟内pod的创建时间改变超过4次的
description: '{{ $value | humanizePercentage }} of Alertmanager instances within the {{$labels.job}} cluster have restarted at least 5 times in the last 10m.'


summary: Alertmanager instances within the same cluster have different configurations：
count by(namespace, service) (count_values by(namespace, service) ("config_hash", alertmanager_config_hash{job="alertmanager-main",namespace="monitoring"})) != 1

alertmanager配置加载失败的，发送告警失败的




 ```