# Домашнее задание к занятию "3.9. Элементы безопасности информационных систем"

## 1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.
Ответ:

![](https://github.com/tasmity/devops-netology/blob/main/image/sec/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202021-12-08%20%D0%B2%2019.15.46.png)

## 2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.
Ответ:

![](https://github.com/tasmity/devops-netology/blob/main/image/sec/IMG_1647.PNG)

![](https://github.com/tasmity/devops-netology/blob/main/image/sec/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202021-12-08%20%D0%B2%2019.46.54.png)

## 3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.
Ответ:
```shell
vagrant@vagrant:~$ sudo apt-get install apache2
vagrant@vagrant:~$ sudo systemctl status apache2
● apache2.service - The Apache HTTP Server
     Loaded: loaded (/lib/systemd/system/apache2.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2021-12-08 16:51:45 UTC; 25s ago
       Docs: https://httpd.apache.org/docs/2.4/
   Main PID: 12002 (apache2)
      Tasks: 55 (limit: 1071)
     Memory: 5.4M
     CGroup: /system.slice/apache2.service
             ├─12002 /usr/sbin/apache2 -k start
             ├─12004 /usr/sbin/apache2 -k start
             └─12005 /usr/sbin/apache2 -k start

Dec 08 16:51:45 vagrant systemd[1]: Starting The Apache HTTP Server...
Dec 08 16:51:45 vagrant apachectl[12001]: AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' direct>
Dec 08 16:51:45 vagrant systemd[1]: Started The Apache HTTP Server.

```
```shell
# создание сертификата
vagrant@vagrant:~$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt
Generating a RSA private key
................................+++++
...................................+++++
writing new private key to '/etc/ssl/private/apache-selfsigned.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:RU
State or Province Name (full name) [Some-State]:Moscow
Locality Name (eg, city) []:Moscow
Organization Name (eg, company) [Internet Widgits Pty Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:172.16.113.135
Email Address []:tasmity@gmail.com
```
```shell
vagrant@vagrant:~$ sudo vi /etc/apache2/conf-available/ssl-params.conf

SSLCipherSuite EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH
SSLProtocol All -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
SSLHonorCipherOrder On
# Disable preloading HSTS for now.  You can use the commented out header line that includes
# the "preload" directive if you understand the implications.
# Header always set Strict-Transport-Security "max-age=63072000; includeSubDomains; preload"
Header always set X-Frame-Options DENY
Header always set X-Content-Type-Options nosniff
# Requires Apache >= 2.4
SSLCompression off
SSLUseStapling on
SSLStaplingCache "shmcb:logs/stapling-cache(150000)"
# Requires Apache >= 2.4.11
SSLSessionTickets Off

```

```shell
# настройка хоста
vagrant@vagrant:~$ sudo vi /etc/apache2/sites-available/default-ssl.conf

ServerAdmin vagrant@localhost
ServerName 172.16.113.135
SSLCertificateFile      /etc/ssl/certs/apache-selfsigned.crt
SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
```
```shell
# настройка переадресации
vagrant@vagrant:~$ sudo vi /etc/apache2/sites-available/000-default.conf

Redirect "/" "https://172.16.113.135/"
```
```shell
# включите модуль Apache для SSL
vagrant@vagrant:~$ sudo a2enmod ssl
Considering dependency setenvif for ssl:
Module setenvif already enabled
Considering dependency mime for ssl:
Module mime already enabled
Considering dependency socache_shmcb for ssl:
Enabling module socache_shmcb.
Enabling module ssl.
See /usr/share/doc/apache2/README.Debian.gz on how to configure SSL and create self-signed certificates.
To activate the new configuration, you need to run:
  systemctl restart apache2
  
vagrant@vagrant:~$ sudo a2enmod headers
Enabling module headers.
To activate the new configuration, you need to run:
  systemctl restart apache2
  
 # включите подготовленный виртуальный хост
vagrant@vagrant:~$ sudo a2ensite default-ssl
Enabling site default-ssl.
To activate the new configuration, you need to run:
  systemctl reload apache2
  
# включить файл ssl-params.conf
vagrant@vagrant:~$ sudo a2enconf ssl-params
Enabling conf ssl-params.
To activate the new configuration, you need to run:
  systemctl reload apache2
  
# проверьте синтаксис на наличие ошибок
vagrant@vagrant:~$ sudo apache2ctl configtest
Syntax OK
```
```shell
# перезапуск сервера
sudo systemctl restart apache2
```

![](https://github.com/tasmity/devops-netology/blob/main/image/sec/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202021-12-08%20%D0%B2%2020.23.12.png)

## 4. Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).
Ответ:
```shell
vagrant@vagrant:~/testssl.sh$ ./testssl.sh -U --sneaky https://itigic.com/

###########################################################
    testssl.sh       3.1dev from https://testssl.sh/dev/
    (dc782a8 2021-12-08 11:50:55 -- )

      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

       Please file bugs @ https://testssl.sh/bugs/

###########################################################

 Using "OpenSSL 1.0.2-chacha (1.0.2k-dev)" [~183 ciphers]
 on vagrant:./bin/openssl.Linux.x86_64
 (built: "Jan 18 17:12:17 2019", platform: "linux-x86_64")


Testing all IPv4 addresses (port 443): 18.158.98.109 18.159.80.129 3.66.136.156
---------------------------------------------------------------------------------------------------------------------
 Start 2021-12-08 20:39:01        -->> 18.158.98.109:443 (itigic.com) <<--

 Further IP addresses:   3.66.136.156 18.159.80.129
 rDNS (18.158.98.109):   ec2-18-158-98-109.eu-central-1.compute.amazonaws.com.
 Service detected:       HTTP


 Testing vulnerabilities

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session tickets
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           OpenSSL handshake didn't succeed
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    potentially NOT ok, "br gzip" HTTP compression detected. - only supplied "/" tested
                                           Can be ignored for static pages or if no secrets in the page
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    VULNERABLE, uses 64 bit block ciphers
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                           https://censys.io/ipv4?q=81516A7C3E5179A9705986DDC828D922042E4C5DDBD47658DA17F18069921B2A could help you to find out
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2
 BEAST (CVE-2011-3389)                     TLS1: ECDHE-ECDSA-AES128-SHA ECDHE-ECDSA-AES256-SHA ECDHE-RSA-AES128-SHA ECDHE-RSA-AES256-SHA AES128-SHA AES256-SHA
                                                 ECDHE-RSA-DES-CBC3-SHA DES-CBC3-SHA
                                           VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


 Done 2021-12-08 20:39:39 [  39s] -->> 18.158.98.109:443 (itigic.com) <<--

---------------------------------------------------------------------------------------------------------------------
 Start 2021-12-08 20:39:39        -->> 18.159.80.129:443 (itigic.com) <<--

 Further IP addresses:   3.66.136.156 18.158.98.109
 rDNS (18.159.80.129):   ec2-18-159-80-129.eu-central-1.compute.amazonaws.com.
 Service detected:       HTTP


 Testing vulnerabilities

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session tickets
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           OpenSSL handshake didn't succeed
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    potentially NOT ok, "br gzip" HTTP compression detected. - only supplied "/" tested
                                           Can be ignored for static pages or if no secrets in the page
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    VULNERABLE, uses 64 bit block ciphers
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                           https://censys.io/ipv4?q=81516A7C3E5179A9705986DDC828D922042E4C5DDBD47658DA17F18069921B2A could help you to find out
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2
 BEAST (CVE-2011-3389)                     TLS1: ECDHE-ECDSA-AES128-SHA ECDHE-ECDSA-AES256-SHA ECDHE-RSA-AES128-SHA ECDHE-RSA-AES256-SHA AES128-SHA AES256-SHA
                                                 ECDHE-RSA-DES-CBC3-SHA DES-CBC3-SHA
                                           VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


 Done 2021-12-08 20:40:15 [  75s] -->> 18.159.80.129:443 (itigic.com) <<--

---------------------------------------------------------------------------------------------------------------------
 Start 2021-12-08 20:40:15        -->> 3.66.136.156:443 (itigic.com) <<--

 Further IP addresses:   18.159.80.129 18.158.98.109
 rDNS (3.66.136.156):    156.136.66.3.in-addr.arpa.
 Service detected:       HTTP


 Testing vulnerabilities

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session tickets
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           OpenSSL handshake didn't succeed
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    potentially NOT ok, "br gzip" HTTP compression detected. - only supplied "/" tested
                                           Can be ignored for static pages or if no secrets in the page
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    VULNERABLE, uses 64 bit block ciphers
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                           https://censys.io/ipv4?q=81516A7C3E5179A9705986DDC828D922042E4C5DDBD47658DA17F18069921B2A could help you to find out
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2
 BEAST (CVE-2011-3389)                     TLS1: ECDHE-ECDSA-AES128-SHA ECDHE-ECDSA-AES256-SHA ECDHE-RSA-AES128-SHA ECDHE-RSA-AES256-SHA AES128-SHA AES256-SHA
                                                 ECDHE-RSA-DES-CBC3-SHA DES-CBC3-SHA
                                           VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


 Done 2021-12-08 20:40:51 [ 111s] -->> 3.66.136.156:443 (itigic.com) <<--

---------------------------------------------------------------------------------------------------------------------
Done testing now all IP addresses (on port 443): 18.158.98.109 18.159.80.129 3.66.136.156
```

## 5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.
Ответ:
```shell
# Генерация ключа
vagrant@vagrant:~$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/vagrant/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/vagrant/.ssh/id_rsa
Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:ed0AX5FFv+QOVH+mTj6Xa104MfkWRh6wtN398EQSwAA vagrant@vagrant
The key's randomart image is:
+---[RSA 3072]----+
|        E.oo.+*B+|
|           oo.*==|
|            o+++X|
|         . ..o*X+|
|        S . ..=B+|
|         .   += =|
|              +=+|
|               +o|
|              .. |
+----[SHA256]-----+
```
```shell
# Копирование ключа
vagrant@vagrant:~$ ssh-copy-id -i ~/.ssh/id_rsa.pub tasmity@192.168.1.5
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/vagrant/.ssh/id_rsa.pub"
The authenticity of host '192.168.1.5 (192.168.1.5)' can't be established.
ECDSA key fingerprint is SHA256:UWUW99OTDHtQUC+5XglTyyR3DNGtLOKBrI/zPHJPXTU.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
Password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'tasmity@192.168.1.5'"
and check to make sure that only the key(s) you wanted were added.
```
```shell
vagrant@vagrant:~$ ssh tasmity@192.168.1.5
Last login: Wed Dec  8 20:28:32 2021
╭─ ~ ···················································································· ✔  with tasmity@192  at 20:39:15 ─╮
╰─                                                                                                                                                                           ─
```

## 6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.
Ответ:
```shell
vagrant@vagrant:~$ mv .ssh/id_rsa .ssh/id_rsa2

vagrant@vagrant:~$ vi .ssh/config
Host tasmity
HostName 192.168.1.5
IdentityFile ~/.ssh/id_rsa2
User tasmity
```
```shell
vagrant@vagrant:~$ ssh tasmity
Last login: Wed Dec  8 20:40:39 2021
╭─~ ···················································································· ✔ with tasmity@192  at 20:46:19 ─╮
╰─
```
## 7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.
Ответ:
```shell
vagrant@vagrant:~$ sudo tcpdump -c 100 -w dump.pcap
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
100 packets captured
166 packets received by filter
0 packets dropped by kernel
```
![](https://github.com/tasmity/devops-netology/blob/main/image/sec/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202021-12-08%20%D0%B2%2021.32.41.png)
