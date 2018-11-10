# auto-add-routes

## 介绍
为使用各类全局代理VPN的windows用户提供国内国外IP的分流服务。原理是将国内IP写进系统路由表，路由表以外的IP走VPN代理。

## 文件说明：

add.txt和del.txt为写入和删除时使用的路由表；

routes-up.bat和routes-down.bat为Tunsafe在连接前和断开后调用的写入/删除路由表的批处理文件。通过Tunsafe的PreUp和PostDown命令调用。

cmroute.dll会被上述两个批处理文件调用，作用是秒载/秒删路由表。即使有数千条路由表也能秒载入，秒删除。

## 使用方法

### Wireguard
#### 1. 下载最新版本Tunsafe，建议使用带rc的版本。

#### 2. 开启Tunsafe的Pre/Post命令功能。在"Option"选择"Allow Pre/Post Commands"

#### 3. 下载[route.zip](https://raw.githubusercontent.com/lmc999/auto-add-routes/master/route.zip)解压到Tunsafe安装目录。

#### 4. Wireguard客户端配置文件加入PreUp,Postdown命令调用批处理文件。

假设你的Tunsafe安装在D盘abc目录下,你需要在客户端配置文件添加以下两条命令

PreUp = start D:\abc\TunSafe\route\routes-up.bat

PostDown = start D:\abc\TunSafe\route\routes-down.bat

设置实例请参考[sample.conf](https://github.com/lmc999/auto-add-routes/blob/master/sample.conf)

#### 5. 正常使用Tunsafe点击connect就会调用routes-up.bat将国内IP写进系统路由表，断开disconnect则会调用routes-down.bat删除路由表。
连接成功后可上 http://ip111.cn/ 测试自己的IP。

### OpenVPN
#### TODO
