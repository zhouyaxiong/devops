#!/usr/bin/python
#！-*- coding:utf-8 -*-
#from fabric.api import run,local,cd,put,lcd
from fabric.api import *
from fabric.colors import *
#定义数组
env.hosts=[
'10.108.15.204',
#'10.108.15.231'
]
#字典中的key,value
env.passwords={
'root@10.108.15.231:22':'123456',
'root@10.108.15.204:22':'123456'
}
from fabric.api import put
def host():
	run('uname -n')
	run('ls /tmp')
	run('echo hello')
        cd('/opt')
	run('touch cd.txt')
        lcd('/opt')
	local('touch lcd.txt')

def hello():
    local('echo hello world')
    print red('hello fabric')

def check():
    local('ls /tmp/')

def remote():
    run('ping www.baidu.com')
def put_task():
	put('/tmp/fabfile.py','/tmp')
	a=local('md5sum /tmp/fabfile.py' )
	b=run('md5sum /tmp/fabfile.py')
	print yellow(a)
	print green(b)
	if a == b:
		print('ok')
	else:
		print('拷贝出错')	