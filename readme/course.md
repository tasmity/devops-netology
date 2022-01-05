# Курсовая работа по итогам модуля "DevOps и системное администрирование"

## 1. Создайте виртуальную машину Linux.
Ответ:
```shell
tasmity@ubuntu:~$ cat /etc/*-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=20.04
DISTRIB_CODENAME=focal
DISTRIB_DESCRIPTION="Ubuntu 20.04.3 LTS"
NAME="Ubuntu"
VERSION="20.04.3 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04.3 LTS"
VERSION_ID="20.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal
```
Настройка работы по ssh:
```shell
tasmity@ubuntu:/etc/netplan$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:16:e6:3c brd ff:ff:ff:ff:ff:ff
    altname enp2s1
    inet 172.16.113.136/24 brd 172.16.113.255 scope global dynamic noprefixroute ens33
       valid_lft 1496sec preferred_lft 1496sec
    inet6 fe80::8e49:e191:9caa:8d47/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever

```
```shell
❯ cat .ssh/config
................................
Host course
HostName 172.16.113.136
User tasmity
IdentityFile ~/.ssh/id_rsa
AddKeysToAgent yes
UseKeychain yes
```
```shell
❯ ssh-copy-id -i ~/.ssh/id_rsa.pub cuorse
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/Users/tasmity/.ssh/id_rsa.pub"
The authenticity of host '172.16.113.136 (172.16.113.136)' can't be established.
ED25519 key fingerprint is SHA256:/u4ZfMj17O8H5CHQUiKrZ7i/7hj074DoeeDenhEAo+E.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
tasmity@172.16.113.136's password:

Number of key(s) added:        1

Now try logging into the machine, with:   "ssh 'cuorse'"
and check to make sure that only the key(s) you wanted were added.
```
```shell
❯ ssh course
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.11.0-43-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

0 updates can be applied immediately.

Your Hardware Enablement Stack (HWE) is supported until April 2025.
Last login: Mon Jan  3 05:42:16 2022 from 172.16.113.1
```
```shell
tasmity@course:~$ cat /etc/hostname 
course.ru

```

## 2. Установите ufw и разрешите к этой машине сессии на порты 22 и 443, при этом трафик на интерфейсе localhost (lo) должен ходить свободно на все порты.
Ответ:
```shell
tasmity@course:~$ sudo ufw default deny incoming
Default incoming policy changed to 'deny'
(be sure to update your rules accordingly)

tasmity@course:~$ sudo ufw default allow outgoing
Default outgoing policy changed to 'allow'
(be sure to update your rules accordingly)

tasmity@course:~$ sudo ufw allow 22
Rules updated
Rules updated (v6)

tasmity@course:~$ sudo ufw allow 443
Rules updated
Rules updated (v6)

tasmity@course:~$ sudo ufw allow in on lo to any
Rules updated
Rules updated (v6)

tasmity@course:~$ sudo ufw allow out on lo to any
Rules updated
Rules updated (v6)

tasmity@course:~$ sudo ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup

tasmity@course:~$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
22                         ALLOW       Anywhere
443                        ALLOW       Anywhere
Anywhere on lo             ALLOW       Anywhere
22 (v6)                    ALLOW       Anywhere (v6)
443 (v6)                   ALLOW       Anywhere (v6)
Anywhere (v6) on lo        ALLOW       Anywhere (v6)

Anywhere                   ALLOW OUT   Anywhere on lo
Anywhere (v6)              ALLOW OUT   Anywhere (v6) on lo
```

## 3. Установите hashicorp vault ([инструкция по ссылке](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started#install-vault)).
Ответ:
```shell
tasmity@course:~$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
OK

tasmity@course:~$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
Hit:1 http://security.ubuntu.com/ubuntu focal-security InRelease
Get:2 https://apt.releases.hashicorp.com focal InRelease [9,495 B]
Hit:3 http://us.archive.ubuntu.com/ubuntu focal InRelease
Get:4 https://apt.releases.hashicorp.com focal/main amd64 Packages [41.1 kB]
Hit:5 http://us.archive.ubuntu.com/ubuntu focal-updates InRelease
Hit:6 http://us.archive.ubuntu.com/ubuntu focal-backports InRelease
Fetched 50.6 kB in 1s (67.6 kB/s)
Reading package lists... Done

tasmity@course:~$ sudo apt-get update && sudo apt-get install vault
Hit:1 http://security.ubuntu.com/ubuntu focal-security InRelease
Hit:2 https://apt.releases.hashicorp.com focal InRelease
Hit:3 http://us.archive.ubuntu.com/ubuntu focal InRelease
Hit:4 http://us.archive.ubuntu.com/ubuntu focal-updates InRelease
Hit:5 http://us.archive.ubuntu.com/ubuntu focal-backports InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following NEW packages will be installed:
  vault
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 69.4 MB of archives.
After this operation, 188 MB of additional disk space will be used.
Get:1 https://apt.releases.hashicorp.com focal/main amd64 vault amd64 1.9.2 [69.4 MB]
Fetched 69.4 MB in 2s (39.6 MB/s)
Selecting previously unselected package vault.
(Reading database ... 164941 files and directories currently installed.)
Preparing to unpack .../archives/vault_1.9.2_amd64.deb ...
Unpacking vault (1.9.2) ...
Setting up vault (1.9.2) ...
Generating Vault TLS key and self-signed certificate...
Generating a RSA private key
..................................++++
...............................................................................................................................++++
writing new private key to 'tls.key'
-----
Vault TLS key and self-signed certificate have been generated in '/opt/vault/tls'.
```
Проверка установки:
```shell
tasmity@course:~$ vault
Usage: vault <command> [args]

Common commands:
    read        Read data and retrieves secrets
    write       Write data, configuration, and secrets
    delete      Delete secrets and configuration
    list        List data or secrets
    login       Authenticate locally
    agent       Start a Vault agent
    server      Start a Vault server
    status      Print seal and HA status
    unwrap      Unwrap a wrapped secret

Other commands:
    audit          Interact with audit devices
    auth           Interact with auth methods
    debug          Runs the debug command
    kv             Interact with Vault's Key-Value storage
    lease          Interact with leases
    monitor        Stream log messages from a Vault server
    namespace      Interact with namespaces
    operator       Perform operator-specific tasks
    path-help      Retrieve API help for paths
    plugin         Interact with Vault plugins and catalog
    policy         Interact with policies
    print          Prints runtime configurations
    secrets        Interact with secrets engines
    ssh            Initiate an SSH session
    token          Interact with tokens
```

## 4. Cоздайте центр сертификации по инструкции ([ссылка](https://learn.hashicorp.com/tutorials/vault/pki-engine?in=vault/secrets-management)) и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).
Ответ:

Использовалась статья ["HashiCorp Vault как центр сертификации (CA) / Vault PKI"](https://itdraft.ru/2020/12/02/hashicorp-vault-kak-czentr-sertifikaczii-ca-vault-pki/)

Подготовка:
```shell
tasmity@course:~$ sudo apt-get install jq
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  libjq1 libonig5
The following NEW packages will be installed:
  jq libjq1 libonig5
0 upgraded, 3 newly installed, 0 to remove and 0 not upgraded.
Need to get 313 kB of archives.
After this operation, 1,062 kB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://us.archive.ubuntu.com/ubuntu focal/universe amd64 libonig5 amd64 6.9.4-1 [142 kB]
Get:2 http://us.archive.ubuntu.com/ubuntu focal-updates/universe amd64 libjq1 amd64 1.6-1ubuntu0.20.04.1 [121 kB]
Get:3 http://us.archive.ubuntu.com/ubuntu focal-updates/universe amd64 jq amd64 1.6-1ubuntu0.20.04.1 [50.2 kB]
Fetched 313 kB in 1s (330 kB/s)
Selecting previously unselected package libonig5:amd64.
(Reading database ... 164947 files and directories currently installed.)
Preparing to unpack .../libonig5_6.9.4-1_amd64.deb ...
Unpacking libonig5:amd64 (6.9.4-1) ...
Selecting previously unselected package libjq1:amd64.
Preparing to unpack .../libjq1_1.6-1ubuntu0.20.04.1_amd64.deb ...
Unpacking libjq1:amd64 (1.6-1ubuntu0.20.04.1) ...
Selecting previously unselected package jq.
Preparing to unpack .../jq_1.6-1ubuntu0.20.04.1_amd64.deb ...
Unpacking jq (1.6-1ubuntu0.20.04.1) ...
Setting up libonig5:amd64 (6.9.4-1) ...
Setting up libjq1:amd64 (1.6-1ubuntu0.20.04.1) ...
Setting up jq (1.6-1ubuntu0.20.04.1) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for libc-bin (2.31-0ubuntu9.2) ...
```
Правим конфиг:
```shell
tasmity@course:~$ sudo vi /etc/vault.d/vault.hcl
......
# HTTP listener
listener "tcp" {
  address = "127.0.0.1:8200"
  tls_disable = 1
}
```
Запуск сервиса:
```shell
tasmity@course:~$ sudo systemctl start vault.service
tasmity@course:~$ systemctl status vault.service
● vault.service - "HashiCorp Vault - A tool for managing secrets"
     Loaded: loaded (/lib/systemd/system/vault.service; disabled; vendor preset: enabled)
     Active: active (running) since Mon 2022-01-03 06:45:46 PST; 2s ago
       Docs: https://www.vaultproject.io/docs/
   Main PID: 2520 (vault)
      Tasks: 7 (limit: 4599)
     Memory: 110.8M
     CGroup: /system.slice/vault.service
             └─2520 /usr/bin/vault server -config=/etc/vault.d/vault.hcl

Jan 03 06:45:46 course.ru vault[2520]:                Log Level: info
Jan 03 06:45:46 course.ru vault[2520]:                    Mlock: supported: true, enabled: true
Jan 03 06:45:46 course.ru vault[2520]:            Recovery Mode: false
Jan 03 06:45:46 course.ru vault[2520]:                  Storage: file
Jan 03 06:45:46 course.ru vault[2520]:                  Version: Vault v1.9.2
Jan 03 06:45:46 course.ru vault[2520]:              Version Sha: f4c6d873e2767c0d6853b5d9ffc77b0d297bfbdf
Jan 03 06:45:46 course.ru vault[2520]: ==> Vault server started! Log data will stream in below:
Jan 03 06:45:46 course.ru vault[2520]: 2022-01-03T06:45:46.244-0800 [INFO]  proxy environment: http_proxy="\"\"" https_proxy="\"\"" no_proxy="\"\""
Jan 03 06:45:46 course.ru vault[2520]: 2022-01-03T06:45:46.245-0800 [WARN]  no `api_addr` value specified in config or in VAULT_API_ADDR; falling back to detection if possibl>
Jan 03 06:45:46 course.ru vault[2520]: 2022-01-03T06:45:46.386-0800 [INFO]  core: Initializing VersionTimestamps for core
```
```shell
tasmity@course:~$ export VAULT_ADDR=http://127.0.0.1:8200
```
Проверка:
```shell
tasmity@course:~$ vault status
Key                Value
---                -----
Seal Type          shamir
Initialized        false
Sealed             true
Total Shares       0
Threshold          0
Unseal Progress    0/0
Unseal Nonce       n/a
Version            1.9.2
Storage Type       file
HA Enabled         false
```
Иницилизируем voult c тремя ключами:
```shell
tasmity@course:~$ vault operator init -key-shares=3 -key-threshold=2
Unseal Key 1: YJjs47lV0coiCdZrFTK9cIxtHtSl5EdHs432GuIzqWH5
Unseal Key 2: NkcdXUYEd1tqg/W9EZSWqoPbIGRuGfBHhKy5Ov1jONfl
Unseal Key 3: XxHEc8tHyfS3rjyVKSovytmFTx7giKBHlXlO4Ucul4lN

Initial Root Token: s.TU1YaLtrNYcDFi9fFxo6ORpE

Vault initialized with 3 key shares and a key threshold of 2. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 2 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated master key. Without at least 2 keys to
reconstruct the master key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.
```
Проверяем:
```shell
tasmity@course:~$ vault status
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       3
Threshold          2
Unseal Progress    0/2
Unseal Nonce       n/a
Version            1.9.2
Storage Type       file
HA Enabled         false
```
Открываем vault:
```shell
tasmity@course:~$ vault operator unseal YJjs47lV0coiCdZrFTK9cIxtHtSl5EdHs432GuIzqWH5
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       3
Threshold          2
Unseal Progress    1/2
Unseal Nonce       5c22b221-5dfb-1229-c5c8-e8a337a16209
Version            1.9.2
Storage Type       file
HA Enabled         false
tasmity@course:~$ vault operator unseal NkcdXUYEd1tqg/W9EZSWqoPbIGRuGfBHhKy5Ov1jONfl
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    3
Threshold       2
Version         1.9.2
Storage Type    file
Cluster Name    vault-cluster-93abc45d
Cluster ID      48fa4b39-0b30-2c67-aaed-671586b88211
HA Enabled      false
```
Подключаемся:
```shell
tasmity@course:~$ vault login s.TU1YaLtrNYcDFi9fFxo6ORpE
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                s.TU1YaLtrNYcDFi9fFxo6ORpE
token_accessor       a65YUh1QETMChssOuMJdToCl
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
```
Создаем корневой центра сертификации (CA). 262800h = 30 лет:
```shell
tasmity@course:~$ vault secrets enable pki
Success! Enabled the pki secrets engine at: pki/

tasmity@course:~$ vault secrets tune -max-lease-ttl=262800h pki
Success! Tuned the secrets engine at: pki/

tasmity@course:~$ vault write -field=certificate pki/root/generate/internal common_name=course.ru ttl=262800 > pki_root_ca.crt

tasmity@course:~$ vault write pki/config/urls issuing_certificates="$VAULT_ADDR/v1/pki/ca" crl_distribution_points="$VAULT_ADDR/v1/pki/crl"
Success! Data written to: pki/config/urls
```
Генерируем запрос на выдачу сертификата для промежуточного центра сертификации:
```shell
tasmity@course:~$ vault secrets enable -path=pki_int pki
Success! Enabled the pki secrets engine at: pki_int/

tasmity@course:~$ vault secrets tune -max-lease-ttl=175200h pki_int
Success! Tuned the secrets engine at: pki_int/

tasmity@course:~$ vault write -format=json pki_int/intermediate/generate/internal common_name="course.ru Intermediate Authority" | jq -r '.data.csr' > pki_intermediate.csr
tasmity@course:~$ vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr format=pem_bundle ttl="175200h"| jq -r '.data.certificate' > intermediate.cert.pem
tasmity@course:~$ vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem
Success! Data written to: pki_int/intermediate/set-signed
```
Создаем роль, с помощью которой будем выдавать сертификаты:
```shell
tasmity@course:~$ vault write pki_int/roles/course_dot_ru allowed_domains="course.ru" allow_bare_domains=true allow_subdomains=true max_ttl="720h"
Success! Data written to: pki_int/roles/course_dot_ru
```
Создаем сертификат на 30 дней:
```shell
tasmity@course:~$ vault write -format=json pki_int/issue/course_dot_ru common_name="course.ru" ttl="720h" > course.ru.raw.json
```
```shell
tasmity@course:~$ vault list pki_int/certs
Keys
----
3c-26-a6-3b-d5-b6-ad-25-7b-ea-35-29-28-53-27-97-36-ea-a9-fe
65-7b-5d-8c-1f-3c-e0-74-a2-a9-46-0a-a4-69-97-8a-90-71-af-ac
```

## 5. Установите корневой сертификат созданного центра сертификации в доверенные в хостовой системе.
Ответ:
```shell
❯ scp course:/home/tasmity/pki_root_ca.crt ./
pki_root_ca.crt
```
![](https://github.com/tasmity/devops-netology/blob/main/image/course/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202022-01-03%20%D0%B2%2019.14.10.png)
![](https://github.com/tasmity/devops-netology/blob/main/image/course/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202022-01-03%20%D0%B2%2019.15.18.png)

## 6. Установите nginx.
Ответ:
```shell
tasmity@course:~$ sudo apt update && sudo apt install nginx
Hit:1 http://security.ubuntu.com/ubuntu focal-security InRelease
Hit:2 http://us.archive.ubuntu.com/ubuntu focal InRelease
Hit:3 http://us.archive.ubuntu.com/ubuntu focal-updates InRelease
Hit:4 https://apt.releases.hashicorp.com focal InRelease
Hit:5 http://us.archive.ubuntu.com/ubuntu focal-backports InRelease
Reading package lists... Done
Building dependency tree
Reading state information... Done
All packages are up to date.
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  libnginx-mod-http-image-filter libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream nginx-common nginx-core
Suggested packages:
  fcgiwrap nginx-doc
The following NEW packages will be installed:
  libnginx-mod-http-image-filter libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream nginx nginx-common nginx-core
0 upgraded, 7 newly installed, 0 to remove and 0 not upgraded.
Need to get 603 kB of archives.
After this operation, 2,134 kB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 nginx-common all 1.18.0-0ubuntu1.2 [37.5 kB]
Get:2 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 libnginx-mod-http-image-filter amd64 1.18.0-0ubuntu1.2 [14.4 kB]
Get:3 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 libnginx-mod-http-xslt-filter amd64 1.18.0-0ubuntu1.2 [12.7 kB]
Get:4 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 libnginx-mod-mail amd64 1.18.0-0ubuntu1.2 [42.5 kB]
Get:5 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 libnginx-mod-stream amd64 1.18.0-0ubuntu1.2 [67.3 kB]
Get:6 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 nginx-core amd64 1.18.0-0ubuntu1.2 [425 kB]
Get:7 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 nginx all 1.18.0-0ubuntu1.2 [3,620 B]
Fetched 603 kB in 1s (600 kB/s)
Preconfiguring packages ...
Selecting previously unselected package nginx-common.
(Reading database ... 164964 files and directories currently installed.)
Preparing to unpack .../0-nginx-common_1.18.0-0ubuntu1.2_all.deb ...
Unpacking nginx-common (1.18.0-0ubuntu1.2) ...
Selecting previously unselected package libnginx-mod-http-image-filter.
Preparing to unpack .../1-libnginx-mod-http-image-filter_1.18.0-0ubuntu1.2_amd64.deb ...
Unpacking libnginx-mod-http-image-filter (1.18.0-0ubuntu1.2) ...
Selecting previously unselected package libnginx-mod-http-xslt-filter.
Preparing to unpack .../2-libnginx-mod-http-xslt-filter_1.18.0-0ubuntu1.2_amd64.deb ...
Unpacking libnginx-mod-http-xslt-filter (1.18.0-0ubuntu1.2) ...
Selecting previously unselected package libnginx-mod-mail.
Preparing to unpack .../3-libnginx-mod-mail_1.18.0-0ubuntu1.2_amd64.deb ...
Unpacking libnginx-mod-mail (1.18.0-0ubuntu1.2) ...
Selecting previously unselected package libnginx-mod-stream.
Preparing to unpack .../4-libnginx-mod-stream_1.18.0-0ubuntu1.2_amd64.deb ...
Unpacking libnginx-mod-stream (1.18.0-0ubuntu1.2) ...
Selecting previously unselected package nginx-core.
Preparing to unpack .../5-nginx-core_1.18.0-0ubuntu1.2_amd64.deb ...
Unpacking nginx-core (1.18.0-0ubuntu1.2) ...
Selecting previously unselected package nginx.
Preparing to unpack .../6-nginx_1.18.0-0ubuntu1.2_all.deb ...
Unpacking nginx (1.18.0-0ubuntu1.2) ...
Setting up nginx-common (1.18.0-0ubuntu1.2) ...
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /lib/systemd/system/nginx.service.
Setting up libnginx-mod-http-xslt-filter (1.18.0-0ubuntu1.2) ...
Setting up libnginx-mod-mail (1.18.0-0ubuntu1.2) ...
Setting up libnginx-mod-http-image-filter (1.18.0-0ubuntu1.2) ...
Setting up libnginx-mod-stream (1.18.0-0ubuntu1.2) ...
Setting up nginx-core (1.18.0-0ubuntu1.2) ...
Setting up nginx (1.18.0-0ubuntu1.2) ...
Processing triggers for systemd (245.4-4ubuntu3.13) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for ufw (0.36-6ubuntu1) ...
```
Проверяем:
```shell
tasmity@course:~$ systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2022-01-03 08:19:11 PST; 48s ago
       Docs: man:nginx(8)
   Main PID: 3889 (nginx)
      Tasks: 3 (limit: 4599)
     Memory: 3.6M
     CGroup: /system.slice/nginx.service
             ├─3889 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
             ├─3890 nginx: worker process
             └─3891 nginx: worker process

Jan 03 08:19:11 course.ru systemd[1]: Starting A high performance web server and a reverse proxy server...
Jan 03 08:19:11 course.ru systemd[1]: Started A high performance web server and a reverse proxy server.
```
## 7. По инструкции ([ссылка](https://nginx.org/en/docs/http/configuring_https_servers.html)) настройте nginx на https, используя ранее подготовленный сертификат:.
+ можно использовать стандартную стартовую страницу nginx для демонстрации работы сервера;
+ можно использовать и другой html файл, сделанный вами;

Ответ:

Конфиг nginx
```shell
cat /etc/nginx/sites-available/default
...
server {
#	listen 80 default_server;
#	listen [::]:80 default_server;

	# SSL configuration
	#
	listen 443 ssl default_server;
	# listen [::]:443 ssl default_server;
	#
	# Note: You should disable gzip for SSL traffic.
	# See: https://bugs.debian.org/773332
	#
	# Read up on ssl_ciphers to ensure a secure configuration.
	# See: https://bugs.debian.org/765782
	#
	# Self signed certs generated by the ssl-cert package
	# Don't use them in a production server!
	#
	# include snippets/snakeoil.conf;

	root /var/www/html;

	# Add index.php to the list if you are using PHP
	index index.html index.htm index.nginx-debian.html;

	server_name _;

	ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers         HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers on;

        ssl_certificate     /etc/ssl/certs/course.ru.crt;
        ssl_certificate_key /etc/ssl/private/course.ru.key;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ =404;
	}

	# pass PHP scripts to FastCGI server
	#
	#location ~ \.php$ {
	#	include snippets/fastcgi-php.conf;
	#
	#	# With php-fpm (or other unix sockets):
	#	fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
	#	# With php-cgi (or other tcp sockets):
	#	fastcgi_pass 127.0.0.1:9000;
	#}

	# deny access to .htaccess files, if Apache's document root
	# concurs with nginx's one
	#
	#location ~ /\.ht {
	#	deny all;
	#}
}
```
Подготавливаем цепочки сертификатов:
```shell
tasmity@course:~$ sudo -i

root@course:~# cat /home/tasmity/course.ru.raw.json | jq -r '.data.certificate' > /etc/ssl/certs/course.ru.crt
root@course:~# cat /home/tasmity/course.ru.raw.json | jq -r '.data.ca_chain[]' >> /etc/ssl/certs/course.ru.crt
root@course:~# cat /home/tasmity/course.ru.raw.json | jq -r '.data.private_key' > /etc/ssl/private/course.ru.key
```
Перезапускаем Nginx:
```shell
tasmity@course:~$ sudo systemctl reload nginx
```
Проверяем:
```shell
tasmity@course:~$ sudo nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

tasmity@course:~$ sudo systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2022-01-03 09:11:45 PST; 18min ago
       Docs: man:nginx(8)
    Process: 4737 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
    Process: 4738 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
   Main PID: 4739 (nginx)
      Tasks: 3 (limit: 4599)
     Memory: 3.4M
     CGroup: /system.slice/nginx.service
             ├─4739 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
             ├─4740 nginx: worker process
             └─4741 nginx: worker process

Jan 03 09:11:45 course.ru systemd[1]: Starting A high performance web server and a reverse proxy server...
Jan 03 09:11:45 course.ru systemd[1]: Started A high performance web server and a reverse proxy server.
```


## 8. Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.
Ответ:

![](https://github.com/tasmity/devops-netology/blob/main/image/course/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202022-01-03%20%D0%B2%2020.35.44.png)

## 9. Создайте скрипт, который будет генерировать новый сертификат в vault:
+ генерируем новый сертификат так, чтобы не переписывать конфиг nginx;
+ перезапускаем nginx для применения нового сертификата.

Ответ:
Создаем скрипт:
```shell
tasmity@course:~$ touch update_ssl.sh

tasmity@course:~$ chmod +x ./update_ssl.sh

tasmity@course:~$ ls -l update_ssl.sh
-rwxrwxr-x 1 tasmity tasmity 443 Jan  3 09:44 update_ssl.sh
```
Предварительно сохранила ключи
```shell
tasmity@course:~# ls /root/vault_key/
key1  key2  key3
```

```shell
tasmity@course:~$ vi update_ssl.sh

#!/usr/bin/env bash

VAULT_TOKEN=$(cat /root/.vault-token)
key1=$(cat /root/vault_key/key1)
key2=$(cat /root/vault_key/key2)

systemctl start vault.service

export VAULT_ADDR=http://127.0.0.1:8200
vault operator unseal ${key1}
vault operator unseal ${key1}
vault login ${VAULT_TOKEN}

vault write -format=json pki_int/issue/course_dot_ru common_name="course.ru" ttl="720h" > course.ru.raw.json
cat /home/tasmity/course.ru.raw.json | jq -r '.data.certificate' > /etc/ssl/certs/course.ru.crt
cat /home/tasmity/course.ru.raw.json | jq -r '.data.ca_chain[]' >> /etc/ssl/certs/course.ru.crt
cat /home/tasmity/course.ru.raw.json | jq -r '.data.private_key' > /etc/ssl/private/course.ru.key

systemctl reload nginx

```
Обновленный сертификат, с новым временем истечения:
![](https://github.com/tasmity/devops-netology/blob/main/image/course/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202022-01-03%20%D0%B2%2023.52.49.png)

## 10. Поместите скрипт в crontab, чтобы сертификат обновлялся какого-то числа каждого месяца в удобное для вас время.
Ответ:

Запуск команды каждый месяц 1 числа в 12:00:
```shell
tasmity@course:~$ crontab -e

tasmity@course:~$ crontab -l
# Edit this file to introduce tasks to be run by cron.
#
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
#
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').
#
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
#
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
#
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
#
# For more information see the manual pages of crontab(5) and cron(8)
#
# m h  dom mon dow   command

0 12 1 * * /home/tasmity/update_ssl.sh
```