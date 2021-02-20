# 关于prometheus-operator的版本

对于老版本的k8s官方的建议是先将版本升至最新再进行部署prometheus-operator
>Version >=0.39.0 of the Prometheus Operator requires a Kubernetes cluster of version >=1.16.0. If you are just starting out with the Prometheus Operator, it is highly recommended to use the latest version.  
If you have an older version of Kubernetes and the Prometheus Operator running, we recommend upgrading Kubernetes first and then the Prometheus Operator.

老版本的prometheus可以使用docker部署的alert-manager



绝大部分传统中间件（比如 MySQL、Kafka、Redis、ES）也有社区提供的 Prometheus Exporter  

prometheus监控kafka常见的有两种开源方案，一种是传统的部署exporter的方式，一种是通过jmx配置监控
1个kafka集群只需要1个exporter

展示模板通过ID进行导入，可用ID有：7589，10466,11963等等





