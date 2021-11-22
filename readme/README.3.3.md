# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

## 1. Какой системный вызов делает команда cd?
В прошлом ДЗ мы выяснили, что cd не является самостоятельной программой, это shell builtin, поэтому запустить strace
непосредственно на cd не получится. Тем не менее, вы можете запустить strace на /bin/bash -c 'cd /tmp'. В этом случае
вы увидите полный список системных вызовов, которые делает сам bash при старте. Вам нужно найти тот единственный,
который относится именно к cd.

Ответ:
```shell
vagrant@vagrant:~$ strace /bin/bash -c 'cd /tmp' 2>&1 | grep "/tmp"
execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7fff8bbc6b00 /* 26 vars */) = 0
stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
chdir("/tmp")
```
```shell
chdir("/tmp")
```
## 2. Попробуйте использовать команду file на объекты разных типов на файловой системе. Например:
```shell
vagrant@netology1:~$ file /dev/tty
/dev/tty: character special (5/0)
vagrant@netology1:~$ file /dev/sda
/dev/sda: block special (8/0)
vagrant@netology1:~$ file /bin/bash
/bin/bash: ELF 64-bit LSB shared object, x86-64
```
Используя strace выясните, где находится база данных file на основании которой она делает свои догадки.

Ответ:
```shell
man file
................................
    These files have a “magic number” stored in a particular place near the beginning of the file that tells the UNIX operating system that
     the file is a binary executable, and which of several types thereof.  The concept of a “magic” has been applied by extension to data
     tion identifying these files is read from /etc/magic and the compiled magic file /usr/share/misc/magic.mgc, or the files in the directory
     /usr/share/misc/magic if the compiled file does not exist.  In addition, if $HOME/.magic.mgc or $HOME/.magic exists, it will be used in
     preference to the system magic files.
................................
```
```shell
vagrant@vagrant:~$ strace file /dev/tty 2>&1 | grep magic
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
stat("/home/vagrant/.magic.mgc", 0x7ffcd6c1e6f0) = -1 ENOENT (No such file or directory)
stat("/home/vagrant/.magic", 0x7ffcd6c1e6f0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
stat("/etc/magic", {st_mode=S_IFREG|0644, st_size=111, ...}) = 0
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
````


## 3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет.
Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях
о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой
системе).

Ответ:
```shell
ps -aux | grep [app_name]     # ищем PID
# допусти получили такой вывод
chrome     3446       user  128u      REG              253,2              16400       2364626 /var/tmp/etilqs_1IlrBRwsveCCxId (deleted) 

lsof -p [app_pd] | grep deleted # ищем дескриптор удаленного файла,
# Допусти получили такой файла
lrwx------. 1 user unix 64 Feb 11 15:31 128 -> /var/tmp/etilqs_1IlrBRwsveCCxId (deleted)

# Теперь можно просто сделать cat /dev/null в FD:
cat /dev/null > /proc/3446/fd/128
# Индекс будет все еще открыт, но теперь он будет иметь длину 0
chrome     3446       user  128u      REG              253,2         0    2364626 /var/tmp/etilqs_1IlrBRwsveCCxId (deleted)
```

## 4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
Ответ:
>Процесс при завершении (как нормальном, так и в результате не обрабатываемого сигнала) освобождает все свои ресурсы
> и становится «зомби» — пустой записью в таблице процессов, хранящей статус завершения, предназначенный для чтения
> родительским процессом.
> 
> Зомби не занимают памяти (как процессы-сироты), но блокируют записи в таблице процессов, размер которой ограничен
> для каждого пользователя и системы в целом. При достижении лимита записей все процессы пользователя, от имени
> которого выполняется создающий зомби родительский процесс, не будут способны создавать новые дочерние процессы.
> 
> Кроме этого, пользователь, от имени которого выполняется родительский процесс, не сможет зайти на консоль
> (локальную или удалённую) или выполнить какие-либо команды на уже открытой консоли (потому что для этого командный
> интерпретатор sh должен создать новый процесс), и для восстановления работоспособности (завершения виновной
> программы) будет необходимо вмешательство системного администратора.


## 5. В iovisor BCC есть утилита opensnoop:
```shell
root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
/usr/sbin/opensnoop-bpfcc
```
На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты? Воспользуйтесь пакетом bpfcc-tools для
Ubuntu 20.04. Дополнительные сведения по установке.

Ответ:
Установка:
```shell
sudo apt-get install bpfcc-tools linux-headers-$(uname -r)
```
```shell
vagrant@vagrant:~$ sudo opensnoop-bpfcc -d1
PID    COMM               FD ERR PATH
1      systemd            12   0 /proc/399/cgroup
606    irqbalance          6   0 /proc/interrupts
606    irqbalance          6   0 /proc/stat
606    irqbalance          6   0 /proc/irq/20/smp_affinity
606    irqbalance          6   0 /proc/irq/0/smp_affinity
772    vminfo              4   0 /var/run/utmp
587    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
587    dbus-daemon        18   0 /usr/share/dbus-1/system-services
```

## 6. Какой системный вызов использует uname -a?
риведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в /proc, где можно
узнать версию ядра и релиз ОС.

Ответ:
```shell
vagrant@vagrant:~$ strace uname -a
......
uname({sysname="Linux", nodename="vagrant", ...}) = 0
uname({sysname="Linux", nodename="vagrant", ...}) = 0
uname({sysname="Linux", nodename="vagrant", ...}) = 0
write(1, "Linux vagrant 5.4.0-80-generic #"..., 105Linux vagrant 5.4.0-80-generic #90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
......
# man
vagrant@vagrant:~$ man uname.2 | grep /proc
       Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.

# Вывод 
vagrant@vagrant:~$ cat /proc/sys/kernel/version
#90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021
vagrant@vagrant:~$ cat /proc/sys/kernel/osrelease
5.4.0-80-generic
```

## 7. Чем отличается последовательность команд через ; и через && в bash? Например:
```shell
root@netology1:~# test -d /tmp/some_dir; echo Hi
Hi
root@netology1:~# test -d /tmp/some_dir && echo Hi
root@netology1:~#
```
Есть ли смысл использовать в bash &&, если применить set -e?

Ответ:
```shell
test -d /tmp/some_dir; echo Hi
# Выполнит указанные команды группой в текущей оболочке
test -d /tmp/some_dir && echo Hi
# Выполнить логическую операцию И. В частности, выполнить сначала указанную команду test -d /tmp/some_dir, а затем
# команду echo Hi при удачном исходе выполнения команды -d /tmp/some_dir. Это укороченная форма логической операции,
# при которой команда echo Hi вообще не выполняется при неудачном исходе выполнения команды -d /tmp/some_dir
```
> Когда эта опция включена, при сбое любой команды, оболочка немедленно завершает работу, как если бы выполнялась
> команда exit специальная встроенная утилита без аргументов, за следующими исключениями:
> 1. Сбой какой-либо отдельной команды в многокомандном конвейере не должен вызывать завершение работы оболочки.
> 2. Параметр -e должен игнорироваться при выполнении составного списка, следующего за while, until, if или 
> зарезервированное слово elif, конвейер, начинающийся с символа ! или любая команда из списка AND-OR, кроме
> последней
> 3. Если статус выхода составной команды, кроме команды подоболочки была результатом сбоя при использовании -e
> игнорировалось, то -e не применяется к этой команде.

Исходя из данных исключений, ответ на вопрос: Есть ли смысл использовать в bash &&, если применить set -e? -
**Да, в некоторых случаях**

## 8. Из каких опций состоит режим bash set -euxo pipefail и почему его хорошо было бы использовать в сценариях?
Ответ:
> e - Когда эта опция включена, при сбое любой команды, оболочка немедленно завершает работу
> 
> u - При подстановке расценивайте неустановленные переменные как ошибку.
> 
> x - Печатайте команды и их аргументы по мере их выполнения.
> 
> o pipefail - Возвращаемое значение конвейера - это статус последней команды для выхода с ненулевым статусом или ноль,
> если ни одна команда не вышла с ненулевым статусом

Данная команда кажется полезной для отладки сценарием, мы получаем последовательный вывод команд и проверяем
корректность заданных переменных, и информацию, где произошла ошибка. Более того, при возникновении ошибки, скрипт не 
продолжит свое выполнение. 

## 9. Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе.
В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов.
Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

Ответ:
```shell
vagrant@vagrant:~$ ps -o stat
STAT
Ss
R+
```
```shell
man ps
................................................................
PROCESS STATE CODES
       Here are the different values that the s, stat and state output specifiers (header "STAT" or "S") will display to describe the state of a process:

               D    uninterruptible sleep (usually IO)
               I    Idle kernel thread
               R    running or runnable (on run queue)
               S    interruptible sleep (waiting for an event to complete)
               T    stopped by job control signal
               t    stopped by debugger during the tracing
               W    paging (not valid since the 2.6.xx kernel)
               X    dead (should never be seen)
               Z    defunct ("zombie") process, terminated but not reaped by its parent

       For BSD formats and when the stat keyword is used, additional characters may be displayed:

               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
               +    is in the foreground process group
........................................................
```
> S - прерывистый сон (ожидание завершения события)
> 
> s - лидер сеанса
> 
> R - работает или запускается (в очереди выполнения)
> 
> **+** - находится не в фоновом режиме