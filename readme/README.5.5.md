# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

## 1. Дайте письменые ответы на следующие вопросы:
+ В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?


+ Ответ:
> Существует два типа развертывания сервисов: replicated и global.
>
> Для реплицированного сервиса вы указываете, сколько идентичных задач хотите запустить. Например, вы решили
> развернуть сервис HTTP с тремя репликами, каждая из которых обслуживает один и тот же контент.
>
> Глобальный сервис — это сервис, который запускает одну задачу на каждой ноде. Предварительно заданного количества
> задач нет. Каждый раз, когда вы добавляете ноду в swarm, оркестратор создает задачу, а планировщик назначает задачу
> новой ноде.
+ Какой алгоритм выбора лидера используется в Docker Swarm кластере?


+ Ответ:
> Используется так называемый алгоритм поддержания распределенного консенсуса — Raft. 
+ Что такое Overlay Network?

Ответ:
> Сетевой overlayдрайвер создает распределенную сеть между несколькими узлами демона Docker. Эта сеть
> находится поверх (перекрывает) сети, специфичные для хоста, позволяя контейнерам, подключенным к ней
> (включая контейнеры службы swarm), безопасно обмениваться данными при включенном шифровании. Docker
> прозрачно обрабатывает маршрутизацию каждого пакета от и к правильному хосту демона Docker и правильному
> контейнеру назначения.

## 2. Создать ваш первый Docker Swarm кластер в Яндекс.Облаке
Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```shell
docker node ls
```
 Ответ:
```shell
╭─······················································································································································· ✔  at 18:18:36  ─╮
╰─  terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of yandex-cloud/yandex...
- Finding latest version of hashicorp/null...
- Finding latest version of hashicorp/local...
- Installing yandex-cloud/yandex v0.71.0...
- Installed yandex-cloud/yandex v0.71.0 (self-signed, key ID E40F590B50BB8E40)
- Installing hashicorp/null v3.1.0...
- Installed hashicorp/null v3.1.0 (signed by HashiCorp)
- Installing hashicorp/local v2.1.0...
- Installed hashicorp/local v2.1.0 (signed by HashiCorp)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
```shell
╭─······················································································································································· ✔  at 18:18:36  ─╮
╰─  terraform validate
Success! The configuration is valid.
```
```shell
╭─······················································································································································· ✔  at 18:18:36  ─╮
╰─  terraform plan
................................
Plan: 13 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_node01 = (known after apply)
  + external_ip_address_node02 = (known after apply)
  + external_ip_address_node03 = (known after apply)
  + external_ip_address_node04 = (known after apply)
  + external_ip_address_node05 = (known after apply)
  + external_ip_address_node06 = (known after apply)
  + internal_ip_address_node01 = "192.168.101.11"
  + internal_ip_address_node02 = "192.168.101.12"
  + internal_ip_address_node03 = "192.168.101.13"
  + internal_ip_address_node04 = "192.168.101.14"
  + internal_ip_address_node05 = "192.168.101.15"
  + internal_ip_address_node06 = "192.168.101.16"

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```
```shell
╭─······················································································································································· ✔  at 18:18:36  ─╮
╰─  terraform apply -auto-approve
................................................................
null_resource.monitoring: Creation complete after 26s [id=4147512048698947603]

Apply complete! Resources: 13 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_node01 = "178.154.203.127"
external_ip_address_node02 = "178.154.200.7"
external_ip_address_node03 = "178.154.206.77"
external_ip_address_node04 = "178.154.202.159"
external_ip_address_node05 = "178.154.201.112"
external_ip_address_node06 = "130.193.51.93"
internal_ip_address_node01 = "192.168.101.11"
internal_ip_address_node02 = "192.168.101.12"
internal_ip_address_node03 = "192.168.101.13"
internal_ip_address_node04 = "192.168.101.14"
internal_ip_address_node05 = "192.168.101.15"
internal_ip_address_node06 = "192.168.101.16"
```
```shell
╭─······················································································································································· ✔  at 18:18:36  ─╮
╰─  ssh centos@178.154.203.127
[centos@node01 ~]$

[centos@node01 ~]$ sudo -i
[root@node01 ~]#

[root@node01 ~]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
4p167fm8cytzrtd2px6udoaph *   node01.netology.yc   Ready     Active         Leader           20.10.12
o5ma9b5njnlq849odvi8k0dq1     node02.netology.yc   Ready     Active         Reachable        20.10.12
bo03fvpdi7ds1ovqelxjs3hvf     node03.netology.yc   Ready     Active         Reachable        20.10.12
g3lztwsglqt1qeywyvytwo0io     node04.netology.yc   Ready     Active                          20.10.12
o0ezfv38fzexnie5ogax2ffwx     node05.netology.yc   Ready     Active                          20.10.12
zr99vm436w4980ozme7e9f4as     node06.netology.yc   Ready     Active                          20.10.12
[root@node01 ~]#
```
## 3. Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.
Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```shell
docker service ls
```
Ответ:
```shell
[root@node01 ~]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
mg1p47cu0yuh   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
7xf9tlr689d8   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
x59j7by2h2mz   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest
u6tq7twn6qx6   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest
75vbonq8ekgt   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
1irrui18x16t   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
5sur3oxet3lf   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
jji0az0mrifh   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```

## 4(*). Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
```shell
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```
Ответ:
> При перезапуске Docker в память каждого узла менеджера загружаются как ключ TLS,
> используемый для шифрования связи между узлами swarm, так и ключ, используемый для
> шифрования и расшифровки журналов Raft на диске. Docker может защитить общий ключ
> шифрования TLS и ключ, используемый для шифрования и расшифровки журналов Raft в состоянии
> покоя, позволяя вам стать владельцем этих ключей и требовать ручной разблокировки ваших
> менеджеров. Эта функция называется автоблокировкой.
> 
> Чтобы включить автоблокировку существующего swarm, устанавливается autolock флаг в true.