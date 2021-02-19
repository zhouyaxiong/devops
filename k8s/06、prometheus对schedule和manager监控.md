
# prometheus实现对kube-scheduler/kube-controller-manager的监控

使用prometheus-operator发现无法发现schedule和control-manager这两个组件，

> 检查发现  
 cat prometheus-serviceMonitorKubeScheduler.yaml   
selector.matchLabels在kube-system这个命名空间下面匹配具有k8s-app=kube-scheduler，app.kubernetes.io/name=kube-scheduler这样的Service，但是系统中没有对应的Service，新建这个service就可了

检查serviceMonitor也可以通过查看这个资源对象或者从rancher中查看


对kube-scheduler的监控
```
yaml文件
apiVersion: v1
kind: Service
metadata:
  namespace: kube-system
  name: kube-scheduler-prometheus-discovery
  labels:
    k8s-app: kube-scheduler
  annotations:
    prometheus.io/scrape: 'true'
spec:
  selector:
    component: kube-scheduler
  type: ClusterIP
  clusterIP: None
  ports:
  - name: http-metrics
    port: 10251
    targetPort: 10251
    protocol: TCP

新建endpoint

apiVersion: v1
kind: Endpoints
metadata:
  labels:
    k8s-app: kube-scheduler
  name: kube-scheduler
  namespace: kube-system
subsets:
  - addresses:
      - ip: 192.168.12.169
    ports:
    - name: http-metrics
      port: 10251
      protocol: TCP

kubectl create -f prometheus-KubeSchedulerService.yaml
创建成功后，在endpoint中已经可以找到这个target了，但是抓取数据出错了(down状态)。
这是因为kube-scheduler组件默认绑定在127.0.0.1上，这里想通过节点ip去访问，所以访问被拒绝了，只要把kube-scheduler绑定地址修改为0.0.0.0即可满足要求。


```
对kube-controller-manager的监控

```
apiVersion: v1
kind: Service
metadata:
  namespace: kube-system
  name: kube-controller-manager-prometheus-discovery
  labels:
    k8s-app: kube-controller-manager
  annotations:
    prometheus.io/scrape: 'true'
spec:
  selector:
    component: kube-controller-manager
  type: ClusterIP
  clusterIP: None
  ports:
  - name: http-metrics
    port: 10252
    targetPort: 10252
    protocol: TCP

后续的步骤类似kube-schdule
```





