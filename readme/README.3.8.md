# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

## 1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```shell
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```
Ответ:
```shell
oute-views>show ip route 95.165.3.31
Routing entry for 95.165.0.0/16
  Known via "bgp 6447", distance 20, metric 0
  Tag 8283, type external
  Last update from 94.142.247.3 6d14h ago
  Routing Descriptor Blocks:
  * 94.142.247.3, from 94.142.247.3, 6d14h ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 8283
      MPLS label: none
```
```shell
show ip route 95.165.3.31
Routing entry for 95.165.0.0/16
  Known via "bgp 6447", distance 20, metric 0
  Tag 8283, type external
  Last update from 94.142.247.3 6d14h ago
  Routing Descriptor Blocks:
  * 94.142.247.3, from 94.142.247.3, 6d14h ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 8283
      MPLS label: none
route-views>show ip bgp 95.165.3.31
BGP routing table entry for 95.165.0.0/16, version 1391417924
Paths: (24 available, best #15, table default)
  Not advertised to any peer
  Refresh Epoch 1
  2497 3356 8359 25513
    202.232.0.2 from 202.232.0.2 (58.138.96.254)
      Origin IGP, localpref 100, valid, external
      path 7FE0EF49C900 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  6939 8359 25513
    64.71.137.241 from 64.71.137.241 (216.218.252.164)
      Origin IGP, localpref 100, valid, external
      path 7FE0484CF520 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3267 1299 8359 25513
    194.85.40.15 from 194.85.40.15 (185.141.126.1)
      Origin IGP, metric 0, localpref 100, valid, external
      path 7FE11C362330 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20912 3257 3356 8359 25513
    212.66.96.126 from 212.66.96.126 (212.66.96.126)
      Origin IGP, localpref 100, valid, external
      Community: 3257:8070 3257:30515 3257:50001 3257:53900 3257:53902 20912:65004
      path 7FE15CBF7AC0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 3
  3303 8359 25513
    217.192.89.50 from 217.192.89.50 (138.187.128.158)
      Origin IGP, localpref 100, valid, external
      Community: 0:151 3303:1004 3303:1006 3303:1030 3303:3054 8359:100 8359:5500 8359:55277
      path 7FE114A0E0F0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  ...
```
## 2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.
Ответ:
```shell
vagrant@vagrant:~$ sudo ip link add dummy0 type dummy
vagrant@vagrant:~$ sudo ip addr add 172.16.113.140/24 dev dummy0
vagrant@vagrant:~$ sudo ip link set dummy0 up

vagrant@vagrant:~$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 00:0c:29:81:3e:2a brd ff:ff:ff:ff:ff:ff
3: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether 42:eb:53:21:a6:bb brd ff:ff:ff:ff:ff:ff

vagrant@vagrant:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:81:3e:2a brd ff:ff:ff:ff:ff:ff
    inet 172.16.113.135/24 brd 172.16.113.255 scope global dynamic eth0
       valid_lft 1774sec preferred_lft 1774sec
    inet6 fe80::20c:29ff:fe81:3e2a/64 scope link
       valid_lft forever preferred_lft forever
3: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 42:eb:53:21:a6:bb brd ff:ff:ff:ff:ff:ff
    inet 172.16.113.140/24 scope global dummy0
       valid_lft forever preferred_lft forever
    inet6 fe80::40eb:53ff:fe21:a6bb/64 scope link
       valid_lft forever preferred_lft forever
```
```shell
vagrant@vagrant:~$ sudo ip route add 192.168.0.0/24 via 172.16.113.1
vagrant@vagrant:~$ sudo ip route add 10.10.0.0/24 via 172.16.113.3
vagrant@vagrant:~$ sudo ip route add 8.8.0.0/16 via 172.16.113.89

vagrant@vagrant:~$ ip route
default via 172.16.113.2 dev eth0 proto dhcp src 172.16.113.135 metric 100
8.8.0.0/16 via 172.16.113.89 dev eth0
10.10.0.0/24 via 172.16.113.3 dev eth0
172.16.113.0/24 dev eth0 proto kernel scope link src 172.16.113.135
172.16.113.0/24 dev dummy0 proto kernel scope link src 172.16.113.140
172.16.113.2 dev eth0 proto dhcp scope link src 172.16.113.135 metric 100
192.168.0.0/24 via 172.16.113.1 dev eth0
```
## 3. роверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.
Ответ:
```shell
vagrant@vagrant:~$ sudo ss -4 -tpan
State          Recv-Q         Send-Q                  Local Address:Port                 Peer Address:Port         Process
LISTEN         0              4096                    127.0.0.53%lo:53                        0.0.0.0:*             users:(("systemd-resolve",pid=770,fd=13))
LISTEN         0              128                           0.0.0.0:22                        0.0.0.0:*             users:(("sshd",pid=835,fd=3))
ESTAB          0              0                      172.16.113.135:22                   172.16.113.1:49998         users:(("sshd",pid=1730,fd=4),("sshd",pid=1690,fd=4))
```
22 порт - ssh

53 порт - systemd-resolve, выполняющая разрешение сетевой имён

## 4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?
Ответ:
```shell
udo ss -4 -upan
State          Recv-Q          Send-Q                         Local Address:Port                   Peer Address:Port         Process
UNCONN         0               0                              127.0.0.53%lo:53                          0.0.0.0:*             users:(("systemd-resolve",pid=770,fd=12))
UNCONN         0               0                        172.16.113.135%eth0:68                          0.0.0.0:*             users:(("systemd-network",pid=1480,fd=17))
```
53 порт - systemd-resolve, выполняющая разрешение сетевой имён

68 порт - Bootstrap Protocol (BOOTP) Client; also used by Dynamic Host Configuration Protocol (DHCP) (Official)

## 5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.
Ответ:
![](https://github.com/tasmity/devops-netology/blob/main/image/network1/Untitled%20Diagram.drawio.png)
