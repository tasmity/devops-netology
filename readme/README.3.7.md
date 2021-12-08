# Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"

## 1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?
Ответ:

```shell
vagrant@vagrant:~$ ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 00:0c:29:81:3e:2a brd ff:ff:ff:ff:ff:ff
```
```shell
ip -s link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    RX: bytes  packets  errors  dropped overrun mcast
    28454      340      0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    28454      340      0       0       0       0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 00:0c:29:81:3e:2a brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast
    207217244  150547   0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    2063441    23683    0       0       0       0
```
```shell
vagrant@vagrant:~$ ls /sys/class/net
eth0  lo
```
```shell
vagrant@vagrant:~$ cat /proc/net/dev
Inter-|   Receive                                                |  Transmit
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
  eth0: 207205700  150404    0    0    0     0          0         0  2053838   23592    0    0    0     0       0          0
    lo:   28454     340    0    0    0     0          0         0    28454     340    0    0    0     0       0          0
```
Если нужен только список сетевых интерфейсов
```shell
vagrant@vagrant:~$ ip a | awk '/state UP/{print $2}'
eth0:
```
В данный момент нет доступа к системе Windows, но насколько я данная команда отобразить все сетевые настройки для всех
сетевых адаптеров:
```shell
ipconfig /all
```
## 2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?
Ответ:
> Link Layer Discovery Protocol (LLDP) — протокол канального уровня, позволяющий сетевому оборудованию оповещать
> оборудование, работающее в локальной сети, о своём существовании и передавать ему свои характеристики, а также
> получать от него аналогичные сведения.
> 
Пакат lldpd. Команда lldpctl.

## 3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.
Ответ:
> VLAN (аббр. от англ. Virtual Local Area Network) — виртуальная локальная компьютерная сеть. Представляет собой группу
> хостов с общим набором требований, которые взаимодействуют так, как если бы они были подключены к широковещательному
> домену независимо от их физического местонахождения. VLAN имеет те же свойства, что и физическая локальная сеть, но
> позволяет конечным членам группироваться вместе, даже если они не находятся в одной физической сети. Такая
> реорганизация может быть сделана на основе программного обеспечения вместо физического перемещения устройств.
```shell
vagrant@vagrant:~$ vconfig

Warning: vconfig is deprecated and might be removed in the future, please migrate to ip(route2) as soon as possible!

Expecting argc to be 3-5, inclusive.  Was: 1

Usage: add             [interface-name] [vlan_id]
       rem             [vlan-name]
       set_flag        [interface-name] [flag-num]       [0 | 1]
       set_egress_map  [vlan-name]      [skb_priority]   [vlan_qos]
       set_ingress_map [vlan-name]      [skb_priority]   [vlan_qos]
       set_name_type   [name-type]

* The [interface-name] is the name of the ethernet card that hosts
  the VLAN you are talking about.
* The vlan_id is the identifier (0-4095) of the VLAN you are operating on.
* skb_priority is the priority in the socket buffer (sk_buff).
* vlan_qos is the 3 bit priority in the VLAN header
* name-type:  VLAN_PLUS_VID (vlan0005), VLAN_PLUS_VID_NO_PAD (vlan5),
              DEV_PLUS_VID (eth0.0005), DEV_PLUS_VID_NO_PAD (eth0.5)
* FLAGS:  1 REORDER_HDR  When this is set, the VLAN device will move the
            ethernet header around to make it look exactly like a real
            ethernet device.  This may help programs such as DHCPd which
            read the raw ethernet packet and make assumptions about the
            location of bytes.  If you don't need it, don't turn it on, because
            there will be at least a small performance degradation.  Default
```
Для того чтобы информация о созданных VLAN'ах сохранилась после перезагрузки, необходимо добавить её в файл /etc/network/interfaces.
```shell
auto vlan1400
iface vlan1400 inet static
        address 192.168.1.1
        netmask 255.255.255.0
        vlan_raw_device eth0
```

## 4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.
Ответ:
> + Mode-0(balance-rr) – Данный режим используется по умолчанию. Balance-rr обеспечивается балансировку нагрузки и
> отказоустойчивость. В данном режиме сетевые пакеты отправляются “по кругу”, от первого интерфейса к последнему. Если
> выходят из строя интерфейсы, пакеты отправляются на остальные оставшиеся. Дополнительной настройки коммутатора не
> требуется при нахождении портов в одном коммутаторе. При разностных коммутаторах требуется дополнительная настройка.
> + Mode-1(active-backup) – Один из интерфейсов работает в активном режиме, остальные в ожидающем. При обнаружении
> проблемы на активном интерфейсе производится переключение на ожидающий интерфейс. Не требуется поддержки от коммутатора.
> + Mode-2(balance-xor) – Передача пакетов распределяется по типу входящего и исходящего трафика по формуле
> ((MAC src) XOR (MAC dest)) % число интерфейсов. Режим дает балансировку нагрузки и отказоустойчивость. Не требуется
> дополнительной настройки коммутатора/коммутаторов.
> + Mode-3(broadcast) – Происходит передача во все объединенные интерфейсы, тем самым обеспечивая отказоустойчивость.
> Рекомендуется только для использования MULTICAST трафика.
> + Mode-4(802.3ad) – динамическое объединение одинаковых портов. В данном режиме можно значительно увеличить
> пропускную способность входящего так и исходящего трафика. Для данного режима необходима поддержка и настройка 
> коммутатора/коммутаторов.
> + Mode-5(balance-tlb) – Адаптивная балансировки нагрузки трафика. Входящий трафик получается только активным
> интерфейсом, исходящий распределяется в зависимости от текущей загрузки канала каждого интерфейса. Не требуется
> специальной поддержки и настройки коммутатора/коммутаторов.
> + Mode-6(balance-alb) – Адаптивная балансировка нагрузки. Отличается более совершенным алгоритмом балансировки
> нагрузки чем Mode-5). Обеспечивается балансировку нагрузки как исходящего так и входящего трафика. Не требуется
> специальной поддержки и настройки коммутатора/коммутаторов.

Конфиг:
```shell
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto bond0 eth0 eth1
# настроим параметры бонд-интерфейса
iface bond0 inet static
# адрес, маска, шлюз. (можно еще что-нибудь по вкусу)
        address 10.0.0.11
        netmask 255.255.255.0
        gateway 10.0.0.254
        # определяем подчиненные (объединяемые) интерфейсы
        bond-slaves eth0 eth1
        # задаем тип бондинга
        bond-mode balance-alb
        # интервал проверки линии в миллисекундах
bond-miimon 100
        # Задержка перед установкой соединения в миллисекундах
bond-downdelay 200
# Задержка перед обрывом соединения в миллисекундах
        bond-updelay 200
```

## 5. Сколько IP адресов в сети с маской /29? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
Ответ:
1. Сколько IP адресов в сети с маской /29?
```shell
vagrant@vagrant:~$ ipcalc 192.168.0.1/29
Address:   192.168.0.1          11000000.10101000.00000000.00000 001
Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
Wildcard:  0.0.0.7              00000000.00000000.00000000.00000 111
=>
Network:   192.168.0.0/29       11000000.10101000.00000000.00000 000
HostMin:   192.168.0.1          11000000.10101000.00000000.00000 001
HostMax:   192.168.0.6          11000000.10101000.00000000.00000 110
Broadcast: 192.168.0.7          11000000.10101000.00000000.00000 111
Hosts/Net: 6                     Class C, Private Internet
```
Количество доступных адресов	8

Количество рабочих адресов для хостов	6

2. Сколько /29 подсетей можно получить из сети с маской /24

 Для того чтобы жто посчитать — надо узнать сколько бит мы добваили к префиксу (выделили на подсети): 29-24=5.
 5 бит позволяют разместить 2 в степени 5 = 32. Отнимаем адрес под подсети и бродкаста 32 - 2 = 30 различных подсетей.
```shell
vagrant@vagrant:~$ ipcalc -s 29 192.168.0.1/24
Address:   192.168.0.1          11000000.10101000.00000000. 00000001
Netmask:   255.255.255.0 = 24   11111111.11111111.11111111. 00000000
Wildcard:  0.0.0.255            00000000.00000000.00000000. 11111111
=>
Network:   192.168.0.0/24       11000000.10101000.00000000. 00000000
HostMin:   192.168.0.1          11000000.10101000.00000000. 00000001
HostMax:   192.168.0.254        11000000.10101000.00000000. 11111110
Broadcast: 192.168.0.255        11000000.10101000.00000000. 11111111
Hosts/Net: 254                   Class C, Private Internet

1. Requested size: 29 hosts
Netmask:   255.255.255.224 = 27 11111111.11111111.11111111.111 00000
Network:   192.168.0.0/27       11000000.10101000.00000000.000 00000
HostMin:   192.168.0.1          11000000.10101000.00000000.000 00001
HostMax:   192.168.0.30         11000000.10101000.00000000.000 11110
Broadcast: 192.168.0.31         11000000.10101000.00000000.000 11111
Hosts/Net: 30                    Class C, Private Internet

Needed size:  32 addresses.
Used network: 192.168.0.0/27
Unused:
192.168.0.32/27
192.168.0.64/26
192.168.0.128/25
```
3. `Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
```shell
10.10.10.0/29
10.10.10.8/29
10.10.10.16/29
10.10.10.24/29
```
## 6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.
Ответ:
```shell
 ipcalc -s 50 100.64.0.0
Address:   100.64.0.0           01100100.01000000.00000000. 00000000
Netmask:   255.255.255.0 = 24   11111111.11111111.11111111. 00000000
Wildcard:  0.0.0.255            00000000.00000000.00000000. 11111111
=>
Network:   100.64.0.0/24        01100100.01000000.00000000. 00000000
HostMin:   100.64.0.1           01100100.01000000.00000000. 00000001
HostMax:   100.64.0.254         01100100.01000000.00000000. 11111110
Broadcast: 100.64.0.255         01100100.01000000.00000000. 11111111
Hosts/Net: 254                   Class A

1. Requested size: 50 hosts
Netmask:   255.255.255.192 = 26 11111111.11111111.11111111.11 000000
Network:   100.64.0.0/26        01100100.01000000.00000000.00 000000
HostMin:   100.64.0.1           01100100.01000000.00000000.00 000001
HostMax:   100.64.0.62          01100100.01000000.00000000.00 111110
Broadcast: 100.64.0.63          01100100.01000000.00000000.00 111111
Hosts/Net: 62                    Class A

Needed size:  64 addresses.
Used network: 100.64.0.0/26
Unused:
100.64.0.64/26
100.64.0.128/25
```
Network:   100.64.0.0/26

## 7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?
Ответ:
ARP таблица
```shell
vagrant@vagrant:~$ arp -n
Address                  HWtype  HWaddress           Flags Mask            Iface
172.16.113.254           ether   00:50:56:f4:98:16   C                     eth0
172.16.113.2             ether   00:50:56:f5:9b:f4   C                     eth0
172.16.113.1             ether   16:7d:da:47:d5:65   C                     eth0
```
Очистить кеш:
```shell
ip -s -s neigh flush all
```
```shell
 arp -d <host>
```

Уже писала, что не имею доступа к Windows, ну судя по информации - arp -a
