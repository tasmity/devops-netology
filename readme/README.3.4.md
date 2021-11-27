# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

## 1. На лекции мы познакомились с node_exporter. 
В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей
production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd,
создайте самостоятельно простой unit-файл для node_exporter:

+ поместите его в автозагрузку,
+ предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например,
на systemctl cat cron),
+ удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически
поднимается.

Ответ:
1. Создаем unit файл
```shell
sudo vi /etc/systemd/system/node_exporter.service
```
```shell
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=vagrant
Group=vagrant
Type=simple
ExecStart=/usr/local/bin/node_exporter $OPTIONS

[Install]
WantedBy=multi-user.target
```
2. Добавляем сервис в автозагрузку, запускаем его, проверяем статус
```shell
sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter
sudo systemctl status node_exporter

● node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Sat 2021-11-27 14:31:20 UTC; 3s ago
   Main PID: 17675 (node_exporter)
      Tasks: 4 (limit: 1071)
     Memory: 1.8M
     CGroup: /system.slice/node_exporter.service
             └─17675 /usr/local/bin/node_exporter

Nov 27 14:31:20 vagrant node_exporter[17675]: level=info ts=2021-11-27T14:31:20.741Z caller=node_exporter.go:112 collector=thermal_zone
Nov 27 14:31:20 vagrant node_exporter[17675]: level=info ts=2021-11-27T14:31:20.741Z caller=node_exporter.go:112 collector=time
Nov 27 14:31:20 vagrant node_exporter[17675]: level=info ts=2021-11-27T14:31:20.741Z caller=node_exporter.go:112 collector=timex
Nov 27 14:31:20 vagrant node_exporter[17675]: level=info ts=2021-11-27T14:31:20.741Z caller=node_exporter.go:112 collector=udp_queues
Nov 27 14:31:20 vagrant node_exporter[17675]: level=info ts=2021-11-27T14:31:20.741Z caller=node_exporter.go:112 collector=uname
Nov 27 14:31:20 vagrant node_exporter[17675]: level=info ts=2021-11-27T14:31:20.741Z caller=node_exporter.go:112 collector=vmstat
Nov 27 14:31:20 vagrant node_exporter[17675]: level=info ts=2021-11-27T14:31:20.741Z caller=node_exporter.go:112 collector=xfs
Nov 27 14:31:20 vagrant node_exporter[17675]: level=info ts=2021-11-27T14:31:20.741Z caller=node_exporter.go:112 collector=zfs
Nov 27 14:31:20 vagrant node_exporter[17675]: level=info ts=2021-11-27T14:31:20.741Z caller=node_exporter.go:191 msg="Listening on" address=:9100
Nov 27 14:31:20 vagrant node_exporter[17675]: level=info ts=2021-11-27T14:31:20.741Z caller=tls_config.go:170 msg="TLS is disabled and it cannot be enabled on the fly." http2=false
```

## 2. Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию.
Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

Ответ:

+ CPU: node_cpu_seconds_total
+ RAM: node_memory_MemAvailable_bytes
+ Disk: node_filesystem_free_bytes
+ Net: node_network_receive_bytes_total; node_network_transmit_bytes_total

## 3. Установите в свою виртуальную машину Netdata.
Воспользуйтесь готовыми пакетами для установки (sudo apt install -y netdata). После успешной установки:

+ в конфигурационном файле /etc/netdata/netdata.conf в секции [web] замените значение с localhost на bind to = 0.0.0.0,
+ добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте vagrant reload:
```shell
config.vm.network "forwarded_port", guest: 19999, host: 19999 
```
После успешной перезагрузки в браузере на своем ПК (не в виртуальной машине) вы должны суметь зайти на localhost:19999.
Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

Ответ:
![](https://github.com/tasmity/devops-netology/blob/main/image/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202021-11-27%20%D0%B2%2018.13.29.png)

![](https://github.com/tasmity/devops-netology/blob/main/image/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202021-11-27%20%D0%B2%2018.13.46.png)

![](https://github.com/tasmity/devops-netology/blob/main/image/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202021-11-27%20%D0%B2%2018.14.13.png)

## 4. Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
Ответ:

Судя по выводу - да:
```shell
vagrant@vagrant:~$ dmesg | grep virt
[    0.003077] CPU MTRRs all blank - virtualized system.
[    0.147965] Booting paravirtualized kernel on KVM
[    3.637438] systemd[1]: Detected virtualization oracle
```

## 5. Как настроен sysctl fs.nr_open на системе по-умолчанию? 
Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (ulimit --help)?

Ответ:
> nr_open: Это означает максимальное количество файловых дескрипторов, которые может выполнять процесс.
выделить. Значение по умолчанию 1024 * 1024 (1048576), которое должно быть
хватит на большинство машин. Фактический лимит зависит от RLIMIT_NOFILE
ограничение ресурса.
```shell
vagrant@vagrant:~$ sysctl fs.nr_open
fs.nr_open = 1048576
```
Но когда мы смотрим "мягкий" лимит, то получаем другое ограничение:
```shell
vagrant@vagrant:~$ ulimit -aS | grep open
open files                      (-n) 1024
```

## 6. Запустите любой долгоживущий процесс (не ls, который отработает мгновенно, а, например, sleep 1h) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через nsenter.
Для простоты работайте в данном задании под root (sudo -i). Под обычным пользователем требуются дополнительные опции (--map-root-user) и т.д.

Ответ:
```shell
vagrant@vagrant:~$ unshare --mount-proc --map-root-user --fork --mount --pid sleep 1h &
[1] 1310

vagrant@vagrant:~$ ps -aux | grep sleep
vagrant     1310  0.0  0.0   8080   584 pts/0    S    15:44   0:00 unshare --mount-proc --map-root-user --fork --mount --pid sleep 1h
vagrant     1311  0.0  0.0   8076   592 pts/0    S    15:44   0:00 sleep 1h
vagrant     1344  0.0  0.0   8900   736 pts/0    S+   15:51   0:00 grep --color=auto sleep

vagrant@vagrant:~$ sudo nsenter --target 1311 --pid --mount

root@vagrant:/# ps -aux | grep sleep
vagrant        1  0.0  0.0   8076   592 pts/0    S    15:44   0:00 sleep 1h
root          13  0.0  0.0   8900   668 pts/0    S+   15:52   0:00 grep --color=auto sleep
```

## 7. Найдите информацию о том, что такое :(){ :|:& };:
Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (это важно, поведение в других ОС не проверялось).
Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов dmesg расскажет, какой
механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов,
которое можно создать в сессии?

Ответ:
>Это определяет функцию с именем : , которая вызывает себя дважды (Код: : | : ). Это происходит в фоновом режиме ( & ).
>После ; определение функции выполнено, и функция : запускается.
>
>Таким образом, каждый экземпляр : начинает два новых : и так далее... Как двоичное дерево процессов...
>
>+ : снова вызывает эту функцию : .
>+ | означает передачу выходных данных в команду.
>+ : после | означает трубу к функции : .
>+ & , в данном случае, означает выполнение предыдущего в фоновом режиме.
>+ Затем есть ; , который известен как разделитель команд.
>+ Наконец, : запускает эту "цепную реакцию", активируя бомбу fork .

```shell
vagrant@vagrant:~$ dmesg
........
[ 2621.449747] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-1.scope
........
```
> Cgroups - это механизм Linux для установки ограничений на системные ресурсы, такие как максимальное количество
> процессов, циклы ЦП, использование ОЗУ и т. д. Это другой, более современный уровень ограничения ресурсов, чем
> ulimit(который использует getrlimit()системный вызов).
> 
> Если вы запустите systemctl status user-<uid>.slice (который представляет контрольную группу пользователя),
> вы можете увидеть текущее и максимальное количество задач (процессов и потоков), разрешенных в этой контрольной
> группе.
```sh
vagrant@vagrant:~$ systemctl status user-$UID.slice
● user-1000.slice - User Slice of UID 1000
     Loaded: loaded
    Drop-In: /usr/lib/systemd/system/user-.slice.d
             └─10-defaults.conf
     Active: active since Sat 2021-11-27 15:10:25 UTC; 1h 1min ago
       Docs: man:user@.service(5)
      Tasks: 12 (limit: 2356)
     Memory: 21.0M
     CGroup: /user.slice/user-1000.slice
             ├─session-1.scope
             │ ├─1107 sshd: vagrant [priv]
             │ ├─1154 sshd: vagrant@pts/0
             │ ├─1155 -bash
             │ ├─1310 unshare --mount-proc --map-root-user --fork --mount --pid sleep 1h
             │ └─1311 sleep 1h
             ├─session-4.scope
             │ ├─18642 sshd: vagrant [priv]
             │ ├─18677 sshd: vagrant@pts/1
             │ ├─18678 -bash
             │ ├─18737 systemctl status user-1000.slice
             │ └─18738 pager
             └─user@1000.service
               └─init.scope
                 ├─1120 /lib/systemd/systemd --user
                 └─1121 (sd-pam)
```
> По умолчанию максимальное количество задач, которое systemd разрешает каждому пользователю, составляет 33% от
> «общесистемного максимума» ( sysctl kernel.threads-max); это обычно составляет ~ 10 000 задач. Если вы хотите
> изменить это ограничение:
>
>В systemd v239 и более поздних версиях пользовательское значение по умолчанию устанавливается с помощью TasksMax = in:
>
> /usr/lib/systemd/system/user-.slice.d/10-defaults.conf
> 
> Чтобы настроить ограничение для конкретного пользователя (которое будет применено немедленно, а также сохранено
> в /etc/systemd/system.control), запустите:
>
>systemctl [--runtime] set-property user-<uid>.slice TasksMax=<value>
> 
>Здесь также можно использовать обычные механизмы отмены настроек модуля (например, systemctl edit), но они потребуют
> перезагрузки. Например, если вы хотите изменить лимит для каждого пользователя, вы можете создать
> /etc/systemd/system/user-.slice.d/15-limits.conf.
>
> В systemd v238 и более ранних версиях пользователя по умолчанию задается через UserTasksMax = in /etc/systemd/logind.conf.
> Для изменения значения обычно требуется перезагрузка.