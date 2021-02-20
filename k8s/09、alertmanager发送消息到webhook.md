# 将alertmanager产生的告警发送到webhook

>  告警 server 负责接收 alertmanager 的 webhook 调用，下面的程序是一个简单的告警server
这段代码的主要功能是开放一个接口（/send），用以接收 webhook 调用

```
#!/usr/bin/python
from flask import Flask, request
import json
app = Flask(__name__)

@app.route('/send', methods=['POST'])
def send():
    try:
        data = json.loads(request.data)
        print("---"*10)
        print(data)
        alerts =  data['alerts']
        for i in alerts:
            print('SEND SMS: ' + str(i))
    except Exception as e:
        print(e)
    return 'ok'

app.run(host="172.30.14.4",port=5000)
```

alertmanager的配置文件  
```
apiVersion: v1
kind: Secret
metadata:
  name: alertmanager-main
  namespace: kube-system
stringData:
  alertmanager.yaml: |-
    global:
      resolve_timeout: 3m   # 每1分钟检测一次是否恢复
    templates:
      - '/etc/alertmanager/config/*.tmpl'

    route:
      receiver: 'webhook2'
      group_by: ['env','instance','type','group','job','alertname']
      group_wait: 10s       # 初次发送告警延时
      group_interval: 10s   # 距离第一次发送告警，等待多久再次发送告警
      repeat_interval: 10h   # 告警重发时间

    receivers:
    - name: 'webhook2'
      webhook_configs:
      - url: 'http://12.30.14.4:5000/send'

```
