# 优化nfs传输速度
如果按以下命令来mount ，传输速度可能很慢， 只有几K到几十K左右
>$ mount -o nolock 192.168.1.220(假设为宿主机ip):/mnt/nfs /mnt/nfs_t 


# 优化思路
## 1、设置块大小 risize和wsize
mount命令的
risize和wsize指定了server端和client端的传输的块大小。
如果没有指定，那么，系统根据nfs的版本来设置缺省的risize和wsize大小。大多数情况是4K（4096bytes），对于nfs v2，最大是8K，

系统缺省的块可能会太大或者太小，这主要取决于你的kernel和你的网卡，
太大或者太小都有可能导致nfs 速度很慢。具体的可以使用Bonnie，iozone等benchmark来测试不同risize和wsize下nfs的速度。(也可以使用dd测试)  
Bonnie是一款极小的测试系统IO性能的工具,

## 2、网络测试和调优
网络在包传输过程，对包要进行分组，过大或者过小都不能很好的利用网络的带宽，
所以对网络要进行测试和调优。
可以使用: 
> $ ping -s 2048 -f hostname   
进行 ping，尝试不同的package size，这样可以看到包的丢失情况。

$ nfsstat －o net  测试nfs使用udp传输时丢包的多少