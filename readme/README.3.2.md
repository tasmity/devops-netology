# Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"

## 1. Какого типа команда cd?
Ответ:
```shell
vagrant@vagrant:~$ type cd
cd is a shell builtin
```
Строго говоря, это вообще никакая не утилита. Ее нет в файловой системе. Это встроенная команда Bash и меняет текущую
папку только для оболочки, в которой выполняется.

## 2. Какая альтернатива без pipe команде grep <some_string> <some_file> | wc -l?
Ответ:
```shell
vagrant@vagrant:~$ grep ls .bash_history | wc -l
6
```
Альтернатива grep с ключом -с, выдает только количество строк, содержащих образец.
```shell
vagrant@vagrant:~$ grep -c ls .bash_history
6
```

## 3. Какой процесс с PID 1 является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?
Ответ:
```shell
vagrant@vagrant:~$ ps -p 1
    PID TTY          TIME CMD
      1 ?        00:00:02 systemd
```

## 4. Как будет выглядеть команда, которая перенаправит вывод stderr ls на другую сессию терминала?
Ответ:
```shell
ls /dir 2>/dev/tty2
```
>Для перенаправления вывода на другой терминал, в linux используются псевдотерминалы. При открытии новой текстовой
консоли, создаётся специальный файл устройства в директории /dev/pts с названием файла в виде порядкового номера
псевдотерминала. Перенаправив вывод программы в файл выбранного псевдотерминала, можно отделить, например, сообщения
об ошибках исполняемой программы от вывода stdout. Например:
```shell
ls /dir 2>/dev/pts/1
```
## 5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл?
Ответ:
```shell
grep -c ls < .bash_history > out.txt
vagrant@vagrant:~$ ls
out.txt
vagrant@vagrant:~$ cat out.txt
6
```

## 6. Получится ли вывести находясь в графическом режиме данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?
Ответ:
```shell
echo "Вывод c псевдотерминала №0. /dev/pts/0" > /dev/tty2
```
>Данное сообщение можно наблюдать в соответствующем терминале.

## 7. Выполните команду bash 5>&1. К чему она приведет? Что будет, если вы выполните echo netology > /proc/$$/fd/5? Почему так происходит?
Ответ:
>bash 5>&1 - в командной строке будет создан новый файловый дескриптор 5 и перенаправлен на 1 который STDOUT
>
>echo netology > /proc/$$/fd/5 - пишем netology в открытый файл с дескриптором 5 и выводим на экран, так как файл
> перенаправлен на stdout

## 8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty?
Ответ:
```shell
vagrant@vagrant:~$ rm tmp/ 8>&1 9>&2 2>&8 1>&9 | grep -o "dir\w*"
directory
```
```shell
vagrant@vagrant:~$ ls tmp/ 8>&1 9>&2 2>&8 1>&9 | grep -o "dir\w*"
directory
```

## 9. Что выведет команда cat /proc/$$/environ? Как еще можно получить аналогичный по содержанию вывод?
Ответ:
> Данная команда выводит исходное окружение, присвоенное процессу оболочки.
```shell
vagrant@vagrant:~$ cat /proc/$$/environ
LC_TERMINAL_VERSION=3.4.12LANG=en_US.UTF-8LC_TERMINAL=iTerm2USER=vagrantLOGNAME=vagrantHOME=/home/vagrantPATH=
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/binSHELL=
/bin/bashTERM=xterm-256colorXDG_SESSION_ID=22XDG_RUNTIME_DIR=/run/user/1000DBUS_SESSION_BUS_ADDRESS=unix:path=
/run/user/1000/busXDG_SESSION_TYPE=ttyXDG_SESSION_CLASS=userMOTD_SHOWN=pamLANGUAGE=en_US:SSH_CLIENT=10.0
```
> Похожий вывод можно получить через команду ps с ключом e:
```shell
vagrant@vagrant:~$ ps e -p $$ | cat
    PID TTY      STAT   TIME COMMAND
   1729 pts/1    Ss     0:00 -bash LC_TERMINAL_VERSION=3.4.12 LANG=en_US.UTF-8 LC_TERMINAL=iTerm2 USER=vagrant 
   LOGNAME=vagrant HOME=/home/vagrant PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:
   /usr/local/games:/snap/bin SHELL=/bin/bash TERM=xterm-256color XDG_SESSION_ID=22 XDG_RUNTIME_DIR=/run/user/1000 
   DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus XDG_SESSION_TYPE=tty XDG_SESSION_CLASS=user MOTD_SHOWN=pam 
   LANGUAGE=en_US: SSH_CLIENT=10.0.2.2 50534 22 SSH_CONNECTION=10.0.2.2 50534 10.0.2.15 22 SSH_TTY=/dev/pts/1
````
## 10. Используя man, опишите что доступно по адресам /proc/<PID>/cmdline, /proc/<PID>/exe.
Ответ:
> /proc/[PID]/cmdline
> 
>Этот доступный только для чтения файл содержит полную командную строку для процесса, если только процесс не зомби.
> B последнем случае, в этом файле ничего нет: то есть чтение этого файла вернет 0 символов. Команда - строковые
> аргументы появляются в этом файле как набор строк разделены нулевыми байтами ('\ 0'), с последующим нулевым байтом
> после последней строки.
> 
> /proc/[PID]/exe
> 
> В Linux 2.2 и новее этот файл представляет собой символическую ссылку, содержащий фактический путь к выполненной
> команде. Эту символическую ссылку можно разыменовать обычным образом; попытка открыть его - откроет исполняемый файл.
> Вы можете даже ввести /proc/[pid]/exe, чтобы запустить еще одну копию того же исполняемого файла, запущенный
> процессом [pid]. Если путь был отключен, символическая ссылка будет содержать строка '(удалена)', добавленная к
> исходному имени пути.

## 11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью /proc/cpuinfo.
Ответ:
```shell
vagrant@vagrant:~$ cat /proc/cpuinfo | grep -oh "sse\w*" | sort
sse
sse
sse2
sse2
sse3
sse3
sse4_1
sse4_1
sse4_2
sse4_2
```
> Судя по выводу: sse4_2

## 12. При открытии нового окна терминала и vagrant ssh создается новая сессия и выделяется pty.
Это можно подтвердить командой tty, которая упоминалась в лекции 3.2. Однако:
```sh
vagrant@netology1:~$ ssh localhost 'tty'
not a tty
````
Почитайте, почему так происходит, и как изменить поведение.

Ответ:
> Надо использовать ssh с ключом -t
> 
> -t - Переназначение псевдотерминала. Это может быть использовано для произвольного выполнения программ базирующихся
> на выводе изображения на удаленной машине, что может быть очень полезно, например, при реализации возможностей меню.
> Несколько параметров -t заданных подряд переназначат терминал, даже если ssh не имеет локального терминала.

## 13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись reptyr
Например, так можно перенести в screen процесс, который вы запустили по ошибке в обычной SSH-сессии.

Ответ:
>reptyr - это утилита для переноса существующей запущенной программы и присоединения ее к новому терминалу.
> 
> -T - Используйте альтернативный режим прикрепления "TTY-stealing". Этот режим более надежен и гибок во многих случаях
> (например, он может подключать все процессы к tty, а не только один процесс). Однако, как недостаток, дочерние
> элементы sshd не могут быть подключены с помощью -T, если reptyr не запущен от имени пользователя root
```shell
reptyr -T 1814
```

## 14. sudo echo string > /root/new_file не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без sudo под вашим пользователем. 
 Для решения данной проблемы можно использовать конструкцию echo string | sudo tee /root/new_file. 
 Узнайте что делает команда tee и почему в отличие от sudo echo команда с sudo tee будет работать.
 
Ответ:

>Команда tee в Linux считывает стандартный ввод и записывает его одновременно в стандартный вывод и в один или несколько
подготовленных файлов.
> 
>Команда будет работать, потому что она сама запускается под sudo.
>Если в случае с sudo echo, под sudo запускалась именно команда echo, а перенаправление идет с правами обычного
>пользователя.
> 
>То во-второй ситуации, echo запускается с правами простого пользователя, а вот запись в файл выполняется командой tee,
>с правами sudo, что позволит записать файл в директории /root


