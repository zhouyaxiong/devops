# NFS --Network File System  网络文件系统

功能
    unix/linux和linux之间文件共享
是局域网共享中速度最快的

什么是网络文件系统？
    网络文件系统是一种将远程主机上的目录经过网络挂载到客户端本地系统的一种机制。


```  
环境：
一、查看软件包是否安装
# rpm -qa | grep nfs
nfs-utils-1.3.0-0.33.el7.x86_64  主程序包
# rpm -qa | grep rpcbind
rpcbind-0.2.0-38.el7.x86_64  提供rpc协议 用来通信

# yum install  nfs-utils  rpcbind -y

服务器端：
二、服务端配置要共享的资源
例：服务器共享/test目录，将/dev/sdb1分区挂载在此目录 
[root@test1 ~]# parted /dev/sdb mklabel gpt 
[root@test1 ~]# parted /dev/sdb mkpart primary 1 3G 
[root@test1 ~]# ll /dev/sd
sda   sda1  sda2  sdb   sdb1
[root@test1 ~]# mkfs.xfs /dev/sdb1
[root@test1 ~]# mkdir /test
[root@test1 ~]# vim /etc/fstab 
/dev/sdb1 /test xfs defaults 0 0
[root@test1 ~]# mount -a
[root@test1 ~]# cd /test
[root@test1 test]# echo "nfs test" > test.txt

三、配置共享/test目录
    1）配置以只读方式共享
    [root@test1 ~]# vim /etc/exports
    # man 5 exports
    共享资源   共享给谁(共享的属性)
    /test  192.168.1.251(ro)

    共享资源：服务器的目录 
    共享给谁：多个主机 之间有空格隔开
        192.168.1.251 某台主机
        192.168.1.0/24 
        192.168.1.0/255.255.255.0
        today.uplook.com 主机名
        *.uplook.com  匹配uplook.com的所有主机
        *       表示任意

    共享的属性：文件系统的属性
        ro             只读
        rw            可读写
        async       异步
        sync         同步
        secure      小于1024端口连接
        insecure   大于1024端口连接
        root_squash          把客户端使用root操作的文件的uid和gid映射为匿名用户（nfsnobady）
        no_root_squash    不映射，以管理员root身份操作
        all_squash    把所有用户创建文件的uid和gid都映射为匿名用户 （nobady）
        
四、重启服务
 systemctl restart nfs-server
 systemctl reload nfs-server   //修改配置文件重新读取  当nfs服务已经启动，可能客户端正在使用，不适合用restart 
 systemctl start rpcbind   
   
五、查看共享资源
    [root@test1 ~]# showmount -e 192.168.1.252(nfs服务器的地址)
    Export list for 192.168.1.252:
    /test 192.168.1.251

客户端：
六、查看共享资源
    [root@client ~]# showmount -e 192.168.1.252
    Export list for 192.168.1.252:
    /test 192.168.1.251

七、挂载
    语法：mount.nfs 服务器地址:服务器共享的目录  本地的挂载点
    [root@client ~]# mount.nfs 192.168.1.252:/test /opt
    [root@client ~]# vim /etc/fstab
    192.168.1.252:/test  /opt  nfs defaults  0 0
    
八、查看是否挂载
[root@client ~]# df -h

九、测试
[root@client ~]# cd /opt
[root@client opt]# ls
[root@client opt]# mkdir a
mkdir: 无法创建目录"a": 只读文件系统
[root@client opt]# cat test.txt 
nfs test

```
 
 


