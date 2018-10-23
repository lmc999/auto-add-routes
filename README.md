# auto-add-routes

## 介绍
为使用各类全局代理VPN的windows用户提供国内国外IP的分流服务。原理是将国内IP写进系统路由表，路由表以外的IP走VPN代理。

## 使用方法

### Wireguard
1. 下载最新版本Tunsafe，建议使用带rc的版本。

2. 开启Tunsafe的Pr/Post功能。在"Option"选择"Allow Pre/Post Commands"

3. 下载route.zip解压得到5个文件，在Tunsafe安装目录建一个名为route的文件夹并将这5个文件全部复制进去。
