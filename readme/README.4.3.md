# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"

## 1. Мы выгрузили JSON, который получили через API-запрос к нашему сервису:
```json
{ "info" : "Sample JSON output from our service\t",
    "elements" :[
        { "name" : "first",
        "type" : "server",
        "ip" : 7175 
        },
        { "name" : "second",
        "type" : "proxy",
        "ip : 71.78.22.43
        }
    ]
}
```
Нужно найти и исправить все ошибки, которые допускают наш сервис

Ответ:
```json
{ "info" : "Sample JSON output from our service\t",
  "elements" :[
    { "name" : "first",
      "type" : "server",
      "ip" : 7175 
    },
    { "name" : "second",
      "type" : "proxy",
      "ip:" : "71.78.22.43"
    }
  ]
}
```

## 2. В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP
К уже реализованному функционалу нужно добавить возможность записи файлов JSON и YAML, описывающих наши сервисы.
Формат записи JSON по одному сервису: {"имя сервиса": "его IP"}. Формат записи YAML по одному сервису: - имя сервиса:
его IP. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле

Ответ:
```python3
#!/usr/bin/env python3

import socket
import json
import yaml
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

with open('data.pickle', 'wb') as ip, open('data.json', 'w') as ip_json, open('data.yaml', 'w') as ip_yaml:
    pickle.dump(ip_dict, ip)
    json.dump(ip_dict, ip_json, indent=4)
    yaml.dump(ip_dict, ip_yaml, default_flow_style=False, sort_keys=False)
```
Вывод:
```shell
❯ python3 test.py
drive.google.com: 74.125.131.194
mail.google.com: 173.194.73.19
[ERROR] google.com IP mismatch: 173.194.73.102 173.194.220.102
google.com: 173.194.220.102

❯ cat data.json
{
    "drive.google.com": "74.125.131.194",
    "mail.google.com": "173.194.73.19",
    "google.com": "173.194.220.102"
}

❯ cat data.yaml
drive.google.com: 74.125.131.194
mail.google.com: 173.194.73.19
google.com: 173.194.220.102
```