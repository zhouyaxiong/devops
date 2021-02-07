
# ingress基于权重调度
+ 但是我们暂时又不希望简单地直接替换掉Service A服务，而是希望将请求头中包含foo=bar或者cookie中包含foo=bar的客户端请求转发到Service A'服务中，
待运行一段时间稳定，将所有的流量切换到Service A'服务中后
+ 

参考链接：https://cloud.tencent.com/developer/article/1475569

## 说明
+ 蓝绿需要新建两套服务，两套pod，两套ingress，ingress的名字可以不一样，但是ingress的host需要配置为一样的
+ Ingress-Nginx 在0.21.0 版本 中，引入的Canary 功能  
ingress-nginx 从 0.21.0 开始支持金丝雀（canary）模式，新建两套服务
+ 权重为0意味着该Canary规则不会向Canary入口中的服务发送任何请求。权重为100意味着所有请求都将被发送到Ingress中指定的替代服务。
+ 主的后面的pod不能是0


## 主备是如何确定的
加了nginx.ingress.kubernetes.io/canary=false就是主的  
加了nginx.ingress.kubernetes.io/canary=true就是备的  
主的后面的pod不能是0，设置为0会发生503错误  
备的service后面的pod可以设置为0   
主备的概念就是处理pod为0这种情况的，备的pod是可以为0的，其pod为0，权重设置为100,流量依旧不会调度到其上，直到备的上面有pod才会将流量调度上去

## 如何设置主备
> 如果在老的ingress中设置了nginx.ingress.kubernetes.io/canary=true,权重给0的话，那么默认访问的ingress是新的，
将canary删除的话，那么会随机访问
这个时候需要将新的ingress设置为nginx.ingress.kubernetes.io/canary=false，nginx.ingress.kubernetes.io/canary-weight=100 这个时候才可以保证流量全部到新的ingress中
然后再将老的ingress中的pod删除就可避免报503的错
然后再将老的ingress删除多没有问题的



## 01、按权重分流
```
创建一个设置了相同 host(域名) 和 path 的 ingress B
配置的时候其中一个ingress开启注释即可（新老那个开启需要确定下）
nginx.ingress.kubernetes.io/canary=true
nginx.ingress.kubernetes.io/canary-weight=60

```

## 02、按请求头分流
```
nginx.ingress.kubernetes.io/canary-by-cookie：基于 Cookie 的流量切分，适用于灰度发布与 A/B 测试
nginx.ingress.kubernetes.io/canary-by-header: "true"
nginx.ingress.kubernetes.io/canary-by-header: "version"
nginx.ingress.kubernetes.io/canary-by-header-value: "canary"

不带有 “version: canary” 头的请求一半被转发给 canary 版本，相关参数为：

基于请求头的测试：
nginx.ingress.kubernetes.io/canary-by-header: "test"
$ for i in $(seq 1 5); do curl http://canary-service.abc.com; echo '\n'; done
hello world-version1
hello world-version1
hello world-version1
hello world-version1
hello world-version1
$ for i in $(seq 1 5); do curl -H 'test:always' http://canary-service.abc.com; echo '\n'; done
hello world-version2
hello world-version2
hello world-version2
hello world-version2

```
