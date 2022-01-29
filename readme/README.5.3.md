# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## 1. Задача 1
Сценарий выполения задачи:
+ создайте свой репозиторий на https://hub.docker.com;
+ выберете любой образ, который содержит веб-сервер Nginx;
+ создайте свой fork образа;
+ реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```html
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

Ответ:

1. Cоздаем репозиторий на Docker hub

![](https://github.com/tasmity/devops-netology/blob/main/image/docker/image1.jpg)

3. Создание страницы сайта:
```shell
❯ mkdir my_page

❯ vi my_page/index.html

<html>
  <head>
    Hey, Netology
  </head>
  <body>
    <h1>I&#39;m DevOps Engineer!</h1>
  </body>
</html>
```

2. Создаем Dockerfile
```shell
❯ docker search nginx

❯ vi Dockerfile

FROM nginx:1.21.6-alpine
COPY my_page /usr/share/nginx/html
EXPOSE 80
```
3. Создание образа
```shell
❯ docker build . -t my_page
[+] Building 0.7s (7/7) FINISHED
 => [internal] load build definition from Dockerfile                                                                                                                                   0.0s
 => => transferring dockerfile: 36B                                                                                                                                                    0.0s
 => [internal] load .dockerignore                                                                                                                                                      0.0s
 => => transferring context: 2B                                                                                                                                                        0.0s
 => [internal] load metadata for docker.io/library/nginx:1.21.6-alpine                                                                                                                 0.6s
 => [internal] load build context                                                                                                                                                      0.0s
 => => transferring context: 331B                                                                                                                                                      0.0s
 => CACHED [1/2] FROM docker.io/library/nginx:1.21.6-alpine@sha256:da9c94bec1da829ebd52431a84502ec471c8e548ffb2cedbf36260fd9bd1d4d3                                                    0.0s
 => [2/2] COPY my_page /usr/share/nginx/html                                                                                                                                           0.0s
 => exporting to image                                                                                                                                                                 0.0s
 => => exporting layers                                                                                                                                                                0.0s
 => => writing image sha256:ae5c0274f81cda024aab1fa9172828d2725a014ba43832a3554d1b9ebd5e23f2                                                                                           0.0s
 => => naming to docker.io/library/my_page
```
4. Запускаем образ
```shell
❯ docker run --name my_page -d -p 8000:80 my_page
43736e24a6bf72c89ee3b70512a21a3187ac74924d5dbad326309fd16f1c806f
```
+ -d - Запустите контейнер в фоновом режиме и распечатайте идентификатор контейнера
+ -p - Публикация портов контейнера на хосте
+ --name - Присвоить имя контейнеру

![](https://github.com/tasmity/devops-netology/blob/main/image/docker/image2.png)

5. Отправка образа в репозиторий
```shell
# Вход на Docrer Hub
❯ docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: tasmity
Password:
WARNING! Your password will be stored unencrypted in /Users/tasmity/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded

# Пристваиваем tag
❯ docker tag my_page:latest tasmity/my_page:latest

# Пуш образа в репозиторий
❯ docker push tasmity/my_page:latest
The push refers to repository [docker.io/tasmity/my_page]
eaf593dfc096: Pushed
6fda88393b8b: Mounted from library/nginx
a770f8eba3cb: Mounted from library/nginx
318191938fd7: Mounted from library/nginx
89f4d03665ce: Mounted from library/nginx
67bae81de3dc: Mounted from library/nginx
8d3ac3489996: Mounted from library/nginx
latest: digest: sha256:04ae29fb9cf4a5a9ad6e213c2b6b239621b072f7228f5f339ab39ee2332616e9 size: 1775
```
[https://hub.docker.com/repository/docker/tasmity/my_page](https://hub.docker.com/repository/docker/tasmity/my_page)

## 2. Задача 2
Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование контейнеров Docker или
лучше подходит виртуальная машина, запуск машины? Может быть возможны разные варианты?"

Детально опишите и обсудите свой выбор.

--

Сценарий:

+ Высоконагруженное монолитное java веб-приложение;
+ Nodejs веб-приложение;
+ Мобильное приложение c версиями для Android и iOS;
+ Шина данных на базе Apache Kafka;
+ Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
+ Мониторинг-стек на базе Prometheus и Grafana;
+ MongoDB, как основное хранилище данных для java-приложения;
+ Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.


 Ответ:
1. Высоконагруженное монолитное java веб-приложение

Скорее виртуалка или физический сервер. JVM — как минимум одна виртуальная машина в Java у нас есть всегда. Не
дает заметного преимущества, потому что JVM сама по себе уже неплохо изолирует нас от внешнего окружения.

2. Nodejs веб-приложение

Использование Docker технологии, позволяет оптимизировать процесс разработки и вывода в продакшн Node.js-проектов.
В данное время уже есть большой опять запуска веб-приложений на docker, много полезного материала. Значительно сокращает
расходы, и упрощает масштабирование.

3. Мобильное приложение c версиями для Android и iOS

Очень плохо ориентируюсь в мобильной разработке. Не совсем понимаю среду, на которой данные приложения тестируются.
Трудно ответить на это вопрос. Но мне кажется потребует эмуляции, а значит уже какой-то виртуально среды. Я бы выбрала
специально подготовленную виртуалку. Хотя даже видела статью сборка Android приложения в docker, но если речь идет о
gradle проекте, то его сборка на docker вообще хороший вариант, но учитывая, что эмулятор они все равно запускают на
виртуалке, еще надо подумать естли в этом смысл.

4. Шина данных на базе Apache Kafka

Я знаю, что подобный подход есть и под Docker, и можно найти примеры реализации, но пока не нашла преимуществ данного
подхода. Так что могу судить только по опыту своей компании. Кафка у нас на виртульных машинах, и целей по ее переезду
на контейнерные технологии пока даже не стоит. Наши сервера кафки используется ни только нашими командами, но и кучей
смежников, имеют очень высокую нагрузку, и должны быть в постоянной доступности.

5. Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana

Ну судя по мнению самих представителей компании и распространенностью примеров и сценариев - видима docker тут самое, что
ни есть подходящие.

6. Мониторинг-стек на базе Prometheus и Grafana

Но могу почти полностью повторить предыдущий ответ. Добавлю лишь, что у нас целевой вариант для них - OpenShift. Что 
опять же говорит об успешном переводе на docker контейнеры. Да и мониторинг вещь нужная, полезная, но не критична для
продолжения стабильной работы.

7. MongoDB, как основное хранилище данных для java-приложения

Опять же сужу по опыту своей компании. В предпочтении физика иногда виртувальные машины, если это не самые большие БД.
Подключение к ним идет с различных клиентов и систем. Объем заливаемых данных весьма приличный. В то же время я никогда
не работал именно с MongoDB, мы используем Oracle и PostgreSQL с целевым переходом на PostgreSQL. Но переезд DB на
контейнерные технологии даже не планируется. И не смотря, на то, что как-то даже на лекции видела успешный пример
перевода PostgreSQL на Docker, пока это не пользуется особой "популярностью".

8. Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

Выбрала бы физические сервера, тут и высокая нагрузка и постоянная доступность, плюс большой объем данных. Критичность
для всех команд компании.
Хотя одна из первых задач для обучения, с которой я сталкивалась, это был именно сервер Gitlab, даже Dockerfile
простенький сохранился)
```shell
FROM ubuntu:16.04

MAINTAINER orubin <orubin@student.21-school.ru>

# installation
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y nano ca-certificates openssh-server wget postfix

RUN wget https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh && chmod 777 script.deb.sh && ./script.deb.sh && apt-get install -y gitlab-ce

RUN apt update && apt install -y tzdata && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure HTTPS
RUN mkdir -p /etc/gitlab/ssl
RUN chmod 700 /etc/gitlab/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
	-subj /C=FR/ST=75/L=Paris/O=rs1/OU=rs1/CN=192.168.100.3/emailAddress=arsciand@student.42.fr \
	-keyout /etc/gitlab/ssl/selfsigned.key -out /etc/gitlab/ssl/selfsigned.crt  

RUN echo "external_url \"https://192.168.100.3\"" >> /etc/gitlab/gitlab.rb
RUN echo "nginx['redirect_http_to_https'] = true" >> /etc/gitlab/gitlab.rb
RUN echo "nginx['ssl_certificate'] = \"/etc/gitlab/ssl/selfsigned.crt\"" >> /etc/gitlab/gitlab.rb
RUN echo "nginx['ssl_certificate_key'] = \"/etc/gitlab/ssl/selfsigned.key\"" >> /etc/gitlab/gitlab.rb
RUN echo "gitlab_rails['gitlab_shell_ssh_port'] = 2222" >> /etc/gitlab/gitlab.rb

EXPOSE 443 80 22

ENTRYPOINT service ssh start &&  (/opt/gitlab/embedded/bin/runsvdir-start &) && gitlab-ctl reconfigure && tail -f /dev/null


# docker build -t gitlab .
# docker run -it --rm -p 80:80 -p 2222:22 -p 443:443 --privileged gitlab
```

## 3. Задача 3
+ Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;
+ Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;
+ Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data;
+ Добавьте еще один файл в папку /data на хостовой машине;
+ Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.

Ответ:
1.  Запуск первого контейнера в фоновом режиме и подключение папки /data
```shell
❯ docker run -di -v /Users/tasmity/data:/data centos
Unable to find image 'centos:latest' locally
latest: Pulling from library/centos
a1d0c7532777: Pull complete
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
2d72d954bfab4e4287c9758b2213dc2e948635461e4599b8f052b87bf6d0cfeb


❯ docker exec -it 2d72d954bfab4e4287c9758b2213dc2e948635461e4599b8f052b87bf6d0cfeb /bin/sh
sh-4.4# ls /
bin  data  dev	etc  home  lib	lib64  lost+found  media  mnt  opt  proc  root	run  sbin  srv	sys  tmp  usr  var
```
2. Запуск второго контейнера в фоновом режиме и подключение папки /data
```shell
❯ docker run -di -v /Users/tasmity/data:/data debian
Unable to find image 'debian:latest' locally
latest: Pulling from library/debian
0c6b8ff8c37e: Pull complete
Digest: sha256:fb45fd4e25abe55a656ca69a7bef70e62099b8bb42a279a5e0ea4ae1ab410e0d
Status: Downloaded newer image for debian:latest
489d90e1fcf704641596aace6d317063d365d077c73a429d879c6745941aacef 


❯ docker exec -it 489d90e1fcf704641596aace6d317063d365d077c73a429d879c6745941aacef /bin/sh
# ls /
bin  boot  data  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
```

3. Создание текстового файла в первом контейнере 
```shell
❯ docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
489d90e1fcf7   debian    "bash"        5 minutes ago    Up 5 minutes              epic_mayer
2d72d954bfab   centos    "/bin/bash"   12 minutes ago   Up 12 minutes             ecstatic_ptolemy

❯ docker exec -ti 2d72d954bfab bash

[root@2d72d954bfab /]# vi /data/test.txt
[root@2d72d954bfab /]# cat /data/test.txt
Test Docker /data folder
```
4. Создание файла на хосте
```shell
❯ cd data
❯ vi host_test.txt
❯ cat host_test.txt
Test2 /data folder
```
5. Просмотр листинга второго контейнера
```shell
 ❯ docker exec -ti 489d90e1fcf7 bash
 
root@489d90e1fcf7:/# ls /data
host_test.txt  test.txt

root@489d90e1fcf7:/# cat /data/*
Test2 /data folder
Test Docker /data folder
```