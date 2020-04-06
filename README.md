# auto-add-routes

## 介绍
为使用各类全局代理VPN的windows用户提供国内国外IP的分流服务。原理是将国内IP写进系统路由表，路由表以外的IP走VPN代理。

## 文件说明：

add.txt和del.txt为写入和删除时使用的路由表；

routes-up.bat和routes-down.bat为Tunsafe在连接前和断开后调用的写入/删除路由表的批处理文件。通过Tunsafe的PreUp和PostDown命令调用。

client_pre.bat和client_down.bat为Openvpn在连接前和断开后调用的写入/删除路由表的批处理文件。Openvpn连接时会自动调用。

cmroute.dll会被上述批处理文件调用，作用是秒载/秒删路由表。即使有数千条路由表也能秒载入，秒删除。

#### `2020-2-22更新：集成Overture DNS服务，国内IP/域名自动使用国内DNS解析；海外域名/IP使用国外DNS解析`

[Overture项目地址](https://github.com/shawn1m/overture)

Overture使用方法可以参考：https://moe.best/tutorial/overture.html

## 分流原理
[请参考wiki](https://github.com/lmc999/auto-add-routes/wiki)

## 使用方法

### Wireguard
#### 1. 下载最新版本Tunsafe，建议使用带rc的版本。

#### 2. 开启Tunsafe的Pre/Post命令功能。在"Option"选择"Allow Pre/Post Commands"

#### 3. 下载[route.zip](https://raw.githubusercontent.com/lmc999/auto-add-routes/master/wireguard/route.zip)解压到Tunsafe安装目录。

#### 4. Wireguard客户端配置文件加入PreUp,Postdown命令调用批处理文件。

假设你的Tunsafe安装在D盘abc目录下,你需要在客户端配置文件添加以下五条命令

PreUp = start D:\abc\TunSafe\route\routes-up.bat

PostUp = start D:\abc\TunSafe\route\dns-up.bat

PostDown = start D:\abc\TunSafe\route\routes-down.bat

PostDown = start D:\software\TunSafe\route\dns-down.bat

ExcludedIPs = 127.0.0.1/32

`然后修改配置文件的DNS地址为本机地址即：127.0.0.1`

设置实例请参考[sample.conf](https://raw.githubusercontent.com/lmc999/auto-add-routes/master/wireguard/sample.conf)

#### 5. 正常使用Tunsafe点击connect就会⑴调用routes-up.bat将国内IP写进系统路由表，⑵启动overture DNS服务

####    断开disconnect则会⑴调用routes-down.bat删除路由表，⑵关闭overture DNS服务

连接成功后可上 http://ip111.cn/ 测试自己的IP。

### Openvpn

#### 1. 下载[client.zip](https://raw.githubusercontent.com/lmc999/auto-add-routes/master/openvpn/client.zip)解压到OPENVPN的config文件夹中，需要确保解压出的文件与你的配置文件client.ovpn保存在同一目录中。

假如你的配置文件不是client.ovpn而是abc.ovpn，你需要将client_pre.bat和client_down.bat分别改名为abc_pre.bat和abc_down.bat，否则OPENVPN无法自动调用批处理文件。

#### 2. OPENVPN点击Connect连接就会调用client_pre.bat将国内IP写进系统路由表，断开disconnect则会调用client_down.bat删除路由表。




## 关于分流后国内访问慢，无法播放网站版权视频/音乐

#### ~~因为你访问的国内网站有海外节点，当你使用WG/OPENVPN时DNS一般默认是8.8.8.8。这是一个海外的DNS，访问有海外节点的网站时会把你解析到海外节点，所以会被认为从大陆地区以外访问，这时候访问网站会变慢或者版权视频/音乐无法播放。解决办法是不要边用WG边上这些网站，这不是域名分流！~~

#### `配搭overture可实现访问国内网站用国内DNS，海外网站使用海外DNS`
