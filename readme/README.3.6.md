# Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"

## 1. Работа c HTTP через телнет.
+ Подключитесь утилитой телнет к сайту stackoverflow.com telnet stackoverflow.com 80
+ отправьте HTTP запрос
```shell
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
```
+ В ответе укажите полученный HTTP код, что он означает?

Ответ:
```shell
❯ telnet stackoverflow.com 80
Trying 151.101.65.69...
Connected to stackoverflow.com.
Escape character is '^]'.
GET /questions HTTP/1.0
HOST: stackoverflow.com

HTTP/1.1 301 Moved Permanently
cache-control: no-cache, no-store, must-revalidate
location: https://stackoverflow.com/questions
x-request-guid: 76527c3e-32c3-4277-a38a-1ff98ec457c8
feature-policy: microphone 'none'; speaker 'none'
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
Accept-Ranges: bytes
Date: Mon, 29 Nov 2021 16:35:20 GMT
Via: 1.1 varnish
Connection: close
X-Served-By: cache-fra19172-FRA
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1638203720.472233,VS0,VE92
Vary: Fastly-SSL
X-DNS-Prefetch-Control: off
Set-Cookie: prov=2303588c-a7bc-dfa1-4d63-d464a0ede576; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly

Connection closed by foreign host.
```
> Код состояния HTTP 301 или Moved Permanently (с англ. — «Перемещено навсегда») — стандартный код ответа HTTP,
> получаемый в ответ от сервера в ситуации, когда запрошенный ресурс был на постоянной основе перемещён в новое
> месторасположение, и указывающий на то, что текущие ссылки, использующие данный URL, должны быть обновлены.
> Адрес нового месторасположения ресурса указывается в поле Location получаемого в ответ заголовка пакета протокола HTTP.

## 2. Повторите задание 1 в браузере, используя консоль разработчика F12.
+ откройте вкладку Network
+ отправьте запрос http://stackoverflow.com
+ найдите первый ответ HTTP сервера, откройте вкладку Headers
+ укажите в ответе полученный HTTP код.
+ проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
+ приложите скриншот консоли браузера в ответ.

Ответ:
![](https://github.com/tasmity/devops-netology/blob/main/image/network1/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202021-11-29%20%D0%B2%2020.02.11.png)
![](https://github.com/tasmity/devops-netology/blob/main/image/network1/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202021-11-29%20%D0%B2%2020.06.03.png)

## 3. Какой IP адрес у вас в интернете?
Ответ:
![](https://github.com/tasmity/devops-netology/blob/main/image/network1/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202021-11-29%20%D0%B2%2020.13.28.png)

## 4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой whois
Ответ:
```shell
vagrant@vagrant:~$  whois 95.165.3.31
% This is the RIPE Database query service.
% The objects are in RPSL format.
%
% The RIPE Database is subject to Terms and Conditions.
% See http://www.ripe.net/db/support/db-terms-conditions.pdf

% Note: this output has been filtered.
%       To receive output for a database update, use the "-B" flag.

% Information related to '95.165.0.0 - 95.165.127.255'

% Abuse contact for '95.165.0.0 - 95.165.127.255' is 'abuse@spd-mgts.ru'

inetnum:        95.165.0.0 - 95.165.127.255
netname:        MGTS-PPPOE
descr:          Moscow Local Telephone Network (OAO MGTS)
country:        RU
admin-c:        USPD-RIPE
tech-c:         USPD-RIPE
status:         ASSIGNED PA
mnt-by:         MGTS-USPD-MNT
created:        2009-11-27T18:33:25Z
last-modified:  2009-11-27T18:33:25Z
source:         RIPE

role:           PJSC Moscow City Telephone Network NOC
address:        USPD MGTS
address:        Moscow, Russia
address:        Khachaturyana 5
admin-c:        AGS9167-RIPE
admin-c:        AVK103-RIPE
admin-c:        GIA45-RIPE
tech-c:         AVK103-RIPE
tech-c:         VMK
tech-c:         ANO3-RIPE
abuse-mailbox:  abuse@spd-mgts.ru
nic-hdl:        USPD-RIPE
mnt-by:         MGTS-USPD-MNT
created:        2006-09-11T07:56:01Z
last-modified:  2021-04-13T10:41:35Z
source:         RIPE # Filtered

% Information related to '95.165.0.0/16AS25513'

route:          95.165.0.0/16
descr:          Moscow Local Telephone Network (OAO MGTS)
descr:          Moscow, Russia
origin:         AS25513
mnt-by:         MGTS-USPD-MNT
created:        2009-01-27T13:52:05Z
last-modified:  2009-01-27T13:52:05Z
source:         RIPE
```
+ Moscow Local Telephone Network (OAO MGTS)
+ AS25513
+ 
## 5.Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой traceroute
Ответ:
```shell
vagrant@vagrant:~$ traceroute -An  8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  172.16.113.2 [*]  0.313 ms  0.257 ms  0.223 ms
 2  192.168.1.1 [*]  16.630 ms  28.175 ms  28.021 ms
 3  95.165.0.1 [AS25513]  27.980 ms  35.350 ms  35.319 ms
 4  212.188.1.106 [AS8359]  46.805 ms  46.774 ms  50.228 ms
 5  212.188.1.105 [AS8359]  51.248 ms  58.545 ms  60.433 ms
 6  212.188.56.13 [AS8359]  65.551 ms  21.790 ms  21.740 ms
 7  195.34.50.74 [AS8359]  28.293 ms  22.736 ms  27.236 ms
 8  212.188.29.82 [AS8359]  32.122 ms  42.367 ms  42.305 ms
 9  108.170.250.130 [AS15169]  81.353 ms  81.306 ms 108.170.250.146 [AS15169]  94.544 ms
10  142.251.49.24 [AS15169]  103.592 ms *  103.502 ms
11  172.253.66.108 [AS15169]  119.642 ms 72.14.238.168 [AS15169]  112.118 ms 72.14.235.69 [AS15169]  67.202 ms
12  142.250.236.77 [AS15169]  53.144 ms 142.250.56.125 [AS15169]  61.977 ms 172.253.79.115 [AS15169]  67.863 ms
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  * * *
22  * * 8.8.8.8 [AS15169]  32.363 ms
```
## 6. Повторите задание 5 в утилите mtr. На каком участке наибольшая задержка - delay?
Ответ:
![](https://github.com/tasmity/devops-netology/blob/main/image/network1/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202021-11-29%20%D0%B2%2021.11.28.png)
10. AS15169  142.251.49.24                  97.0%   102   26.8  26.6  25.3  27.6   1.1
## 7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой dig
Ответ:
```shell
vagrant@vagrant:~$ dig ns dns.google

; <<>> DiG 9.16.1-Ubuntu <<>> ns dns.google
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 26890
;; flags: qr rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;dns.google.			IN	NS

;; ANSWER SECTION:
dns.google.		5	IN	NS	ns1.zdns.google.
dns.google.		5	IN	NS	ns4.zdns.google.
dns.google.		5	IN	NS	ns3.zdns.google.
dns.google.		5	IN	NS	ns2.zdns.google.

;; Query time: 15 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Mon Nov 29 18:19:14 UTC 2021
;; MSG SIZE  rcvd: 116
```
+ ns1.zdns.google.
+ ns4.zdns.google.
+ ns3.zdns.google.
+ ns2.zdns.google.
```shell
vagrant@vagrant:~$ dig a dns.google

; <<>> DiG 9.16.1-Ubuntu <<>> a dns.google
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 36443
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;dns.google.			IN	A

;; ANSWER SECTION:
dns.google.		5	IN	A	8.8.8.8
dns.google.		5	IN	A	8.8.4.4

;; Query time: 11 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Mon Nov 29 18:21:42 UTC 2021
;; MSG SIZE  rcvd: 71
```
+ 8.8.8.8
+ 8.8.4.4

## 8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой dig
Ответ:
```shell
vagrant@vagrant:~$ dig -x 8.8.8.8

; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.8.8
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 59521
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;8.8.8.8.in-addr.arpa.		IN	PTR

;; ANSWER SECTION:
8.8.8.8.in-addr.arpa.	0	IN	PTR	dns.google.

;; Query time: 0 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Mon Nov 29 18:30:21 UTC 2021
;; MSG SIZE  rcvd: 63
```
```shell
vagrant@vagrant:~$ dig -x 8.8.4.4

; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.4.4
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 29258
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;4.4.8.8.in-addr.arpa.		IN	PTR

;; ANSWER SECTION:
4.4.8.8.in-addr.arpa.	5	IN	PTR	dns.google.

;; Query time: 12 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Mon Nov 29 18:24:36 UTC 2021
;; MSG SIZE  rcvd: 73
```
dns.google.