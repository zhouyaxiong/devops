# **kafka监控指标**
将jmxtrans和influxdb部署在k8s中，一个机房部署一套

# broker度量指标
日志监控，监控state-change.log文件

```
同步失效的副本数/非同步分区
kafka.server:type=ReplicaManager,name=UnderReplicatedPartitions

Controller存活数量(一个集群只有一个)
kafka.controller:type=KafkaController,name=ActiveControllerCount

Broker I/O工作处理线程空闲率/请求处理空闲率（低于20%说明存在性能问题）
kafka.network:type=SocketServer,name=NetworkProcessorAvgIdlePercent

Topic消息入站速率（Byte）/主题流入字节(评估是否比其他broker多接收了内容)
kafka.server:type=BrokerTopicMetrics,name=BytesInPerSec


Topic消息出站速率（Byte）/主题流出字节（可以多消费者客户端支持，所以流出最多可以比流入高6倍之多）
kafka.server:type=BrokerTopicMetrics,name=BytesOutPerSec


Topic消息入站速率（message）
kafka.server:type=BrokerTopicMetrics,name=MessagesInPerSec

Leader副本数
kafka.server:type=ReplicaManager,name=LeaderCount

Partition数量
kafka.server:type=ReplicaManager,name=PartitionCount

下线Partition数量（无leader的分区）
kafka.controller:type=KafkaController,name=OfflinePartitionsCount

ISR变化速率(不管是什么原因，如果IsrShrinksPerSec（ISR缩水） 增加了，但并没有随之而来的IsrExpandsPerSec（ISR扩展）的增加，就将引起重视并人工介入)
kafka.server:type=ReplicaManager,name=IsrShrinksPerSec


```
## topic的度量指标
和broker的度量指标类似，不过topic的度量中加了topic的名字  
消息入站速率（Byte）
kafka.server:type=BrokerTopicMetrics,name=BytesInPerSec,topic=TOPICNAME



