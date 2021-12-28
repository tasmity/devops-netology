# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## 1. Есть скрипт:
```shell
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```
+ Какое значение будет присвоено переменной c?
+ Как получить для переменной c значение 12?
+ Как получить для переменной c значение 3?

Ответ:
+ TypeError: unsupported operand type(s) for +: 'int' and 'str'
+ c = str(a) + b
+ c = a + int(b)
+ 
## 2. Мы устроились на работу в компанию, где раньше уже был DevOps Engineer.
Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений.
Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный
путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?
```shell
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```
Ответ:
```python3
#!/usr/bin/env python3

import os

path = "~/sysadm-homeworks"
bash_command = ["cd " + path, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(f'{path}/{prepare_result}')
    
```
Вывод:
```shell
❯ python3 test.py
~/sysadm-homeworks/01-intro-01/netology.jsonnet
~/sysadm-homeworks/01-intro-01/netology.md
~/sysadm-homeworks/01-intro-01/netology.sh
~/sysadm-homeworks/01-intro-01/netology.tf
~/sysadm-homeworks/01-intro-01/netology.yaml
```

## 3. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр.
Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются
локальными репозиториями.

Ответ:
```python3
#!/usr/bin/env python3

import os
import sys
import subprocess

if (len(sys.argv) != 2):
    print("Not path")
    exit(1)

path = sys.argv[1]

if (not(os.path.isdir(path))):
    print("No such file or directory")
    exit(1)

if subprocess.call(["git", "-C", path, "status"], stderr=subprocess.STDOUT, stdout=open(os.devnull, 'w')) != 0:
    print("Not a git!")
    exit(1)
else:
    bash_command = ["cd " + path, "git status"]
    result_os = os.popen(' && '.join(bash_command)).read()
    for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', '')
            print(f'{path}/{prepare_result}')
```
Вывод:
```shell
❯ python3 test.py
Not path
❯ python3 test.py ~/app
Not a git!
❯ python3 test.py ~/sysadm-homeworks
/Users/tasmity/sysadm-homeworks/01-intro-01/netology.jsonnet
/Users/tasmity/sysadm-homeworks/01-intro-01/netology.md
/Users/tasmity/sysadm-homeworks/01-intro-01/netology.sh
/Users/tasmity/sysadm-homeworks/01-intro-01/netology.tf
/Users/tasmity/sysadm-homeworks/01-intro-01/netology.yaml
```

## 4. Наша команда разрабатывает несколько веб-сервисов, доступных по http. 
Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где
установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера,
поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не
беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для
разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в
стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP
сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод
сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала
сервисы: drive.google.com, mail.google.com, google.com.

Ответ:
```python3
#!/usr/bin/env python3

import socket
import pickle


hosts = ["drive.google.com", "mail.google.com", "google.com"]

try:
    with open('data.pickle', 'rb') as ip:
        ip_dict = pickle.load(ip)
except IOError:
    ip_dict = {}

for host in hosts:
    new_ip = socket.gethostbyname(host)
    if host not in ip_dict:
        ip_dict[host] = new_ip
    else:
        if new_ip != ip_dict[host]:
            print(f'[ERROR] {host} IP mismatch: {ip_dict[host]} {new_ip}')
            ip_dict[host] = new_ip
    print(f'{host}: {new_ip}')

with open('data.pickle', 'wb') as ip:
    pickle.dump(ip_dict, ip)
```
Вывод:
```shell
❯ python3 test.py
drive.google.com: 74.125.131.194
mail.google.com: 74.125.131.19
google.com: 173.194.73.113

❯ python3 test.py
drive.google.com: 74.125.131.194
mail.google.com: 74.125.131.19
[ERROR] google.com IP mismatch: 173.194.73.113 173.194.220.113
google.com: 173.194.220.113

❯ python3 test.py
drive.google.com: 74.125.131.194
[ERROR] mail.google.com IP mismatch: 74.125.131.19 173.194.73.83
mail.google.com: 173.194.73.83
google.com: 173.194.220.113
```