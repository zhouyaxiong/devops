# grafana备份工具：
> 链接：https://github.com/ysde/grafana-backup-tool


## 安装
```
1、安装前的准备
使用root用户,：
yum install python-pip -y
yum install python27-python python-requests -y
pip install --upgrade pip
sudo pip3.6 install .
2、安装备份工具：
cd /app/newgetui/shell
git clone https://github.com/ysde/grafana-backup-tool.git
cd grafana-backup-tool

修改配置文件：
conf/grafanaSettings.json
{
  "general": {
    "debug": true,
    "verify_ssl": true,
    "backup_dir": "_OUTPUT_",
    "backup_file_format": "%Y%m%d%H%M",
    "pretty_print": false
  },
  "grafana": {
    "url": "http://grafana地址",
    "token": "grafana dashboard生成tocken",
    "search_api_limit": 5000,
    "default_password": "00000000",
    "admin_account": "管理员用户名",
    "admin_password": "管理员密码"
  }
}

注意先修改配置文件再执行pip安装,将主机ip和端口编译进去
3、pip进行安装
sudo  pip3.6 install .   #这里使用3.6的安装包进行安装
pip3.6 list | grep grafana_backup 确保grafana这个包安装上了


```
## 使用
```
备份命令:grafana-backup save
to backup all your folders, dashboards, datasources and alert channels to the _OUTPUT_ subdirectory of the current directory.

$ grafana-backup save
$ tree _OUTPUT_
_OUTPUT_/
└── 202006272027.tar.gz


恢复命令：grafana-backup restore
注意这可能会由于覆盖服务器上的数据而导致数据丢失。
$ grafana-backup restore _OUTPUT_/202006272027.tar.gz

```





