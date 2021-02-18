# alertmanager--告警多了就是反模式
> grafana告警的缺点：  
老实说grafana告警不是很好用，也不能分级告警，容易产生告警风暴   
Grafana 的报警功能，但是 Grafana 的报警功能目前还比较弱，只支持 Graph 的图表的报警，使用prometheus-alertmanager替代grafana上的告警


> Prometheus Alertmanager的优势(见语雀和prometheus书)：  
    防止告警风暴，达到告警收敛目的  
    设置时间段，对接收到的同类告警只发送一条  
    系统出问题同类告警只发送一条  
    配置文件配置  

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
