# Домашнее задание к занятию "6.3. MySQL"

## 1. Задача 1
Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Ответ:
```shell
❯ vi docker-compose.yml
```
```yaml
version: "3.8"

services:

  db:
    image: mysql:8
    container_name: mysql8
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: kOjzgsF
    ports:
      - 3306:3306
    volumes:
      - db:/var/lib/mysql

  adminer:
    image: adminer
    restart: always
    ports:
      - 8080:8080


volumes:
  db:
```
```shell
❯ docker-compose up -d

Creating network "mysql_default" with the default driver
Creating volume "mysql_db" with default driver
Pulling db (mysql:8)...
8: Pulling from library/mysql
f003217c5aae: Pull complete
65d94f01a09f: Pull complete
43d78aaa6078: Pull complete
a0f91ffbdf69: Pull complete
59ee9e07e12f: Pull complete
04d82978082c: Pull complete
70f46ebb971a: Pull complete
db6ea71d471d: Pull complete
c2920c795b25: Pull complete
26c3bdf75ff5: Pull complete
9ec1f1f78b0e: Pull complete
4607fa685ac6: Pull complete
Digest: sha256:1c75ba7716c6f73fc106dacedfdcf13f934ea8c161c8b3b3e4618bcd5fbcf195
Status: Downloaded newer image for mysql:8
Creating mysql8          ... done
Creating mysql_adminer_1 ... done


❯ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                               NAMES
7bcc9be547b6   adminer   "entrypoint.sh docke…"   20 seconds ago   Up 19 seconds   0.0.0.0:8080->8080/tcp              mysql_adminer_1
c450143d53a8   mysql:8   "docker-entrypoint.s…"   20 seconds ago   Up 19 seconds   0.0.0.0:3306->3306/tcp, 33060/tcp   mysql8

```

Изучите бэкап БД и восстановитесь из него.

Ответ:
```shell
#Копируем test_dump.sql
❯ docker cp test_dump.sql c450143d53a8:/var/tmp/backup_dump.sql

❯ docker exec -it c450143d53a8  sh

$ ls /var/tmp
backup_dump.sql
#
```

```shell
#Создание базы данных
$ mysql -uroot -p"kOjzgsF"

mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 8.0.28 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.


mysql> CREATE DATABASE new_db;
Query OK, 1 row affected (0.00 sec)

mysql> exit
Bye



$ mysql -uroot -p"kOjzgsF" new_db < /var/tmp/backup_dump.sql
```

Перейдите в управляющую консоль mysql внутри контейнера.

Ответ:
```shell
$ mysql -uroot -p"kOjzgsF"

mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.28 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

Используя команду \h получите список управляющих команд.

Отвеет:
```shell
mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.

For server side help, type 'help contents'
```

Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.

Ответ:
```shell
mysql> \s
--------------
mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)
................................................................

```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

Ответ:
```shell
mysql> USE new_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed


mysql> SHOW TABLES;
+------------------+
| Tables_in_new_db |
+------------------+
| orders           |
+------------------+
1 row in set (0.01 sec)
```
Приведите в ответе количество записей с price > 300.

Ответ:
```shell
mysql> SELECT COUNT(*) FROM orders WHERE price > 300;
+----------+
| COUNT(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```
В следующих заданиях мы будем продолжать работу с данным контейнером.


## 2. Задача 2
Создайте пользователя test в БД c паролем test-pass, используя:

- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней
- количество попыток авторизации - 3
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
     - Фамилия "Pretty"
     - Имя "James"

Ответ:
```shell
mysql> CREATE USER 'test'@'localhost' IDENTIFIED WITH mysql_native_password BY 'test-pass';
Query OK, 0 rows affected (0.00 sec)

mysql> ALTER USER 'test'@'localhost' PASSWORD EXPIRE INTERVAL 180 DAY;
Query OK, 0 rows affected (0.00 sec)

mysql> ALTER USER 'test'@'localhost' FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME UNBOUNDED;
Query OK, 0 rows affected (0.00 sec)

mysql> ALTER USER 'test'@'localhost' WITH MAX_QUERIES_PER_HOUR 100;
Query OK, 0 rows affected (0.01 sec)

mysql> ALTER USER 'test'@'localhost' ATTRIBUTE '{"firstname":"James", "lastname":"Pretty"}';
Query OK, 0 rows affected (0.00 sec)
```

Предоставьте привелегии пользователю test на операции SELECT базы test_db. 

Отыет:
```shell
# БД у меня названа new_db, не думаю что это принципиально

mysql> GRANT SELECT ON new_db.* TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.00 sec)
```

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и
приведите в ответе к задаче.

Ответ:
```shell
mysql>  SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE user='test';
+------+-----------+----------------------------------------------+
| USER | HOST      | ATTRIBUTE                                    |
+------+-----------+----------------------------------------------+
| test | localhost | {"lastname": "Pretty", "firstname": "James"} |
+------+-----------+----------------------------------------------+
1 row in set (0.00 sec)
```

## 3. Задача 3
Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;.

Ответ:
```shell
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)
```

```shell
SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE user='test';
SELECT COUNT(*) FROM orders WHERE price > 300;
```

```shell
mysql> SHOW PROFILES;
+----------+------------+--------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                              |
+----------+------------+--------------------------------------------------------------------+
|        1 | 0.00048400 | SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE user='test' |
|        2 | 0.00032600 | SELECT COUNT(*) FROM orders WHERE price > 300                      |
+----------+------------+--------------------------------------------------------------------+
2 rows in set, 1 warning (0.00 sec)
```
Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.

Ответ:
```shell
# БД у меня названа new_db, не думаю что это принципиально

mysql> SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'new_db';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.00 sec)
```
Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:

- на MyISAM
- на InnoDB

Ответ:
```shell
mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.02 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.03 sec)
Records: 5  Duplicates: 0  Warnings: 0
```

```shell
mysql> SHOW PROFILES;
+----------+------------+----------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                  |
+----------+------------+----------------------------------------------------------------------------------------+
|        1 | 0.00048400 | SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE user='test'                     |
|        2 | 0.00032600 | SELECT COUNT(*) FROM orders WHERE price > 300                                          |
|        3 | 0.00104875 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'new_db' |
|        4 | 0.01976425 | ALTER TABLE orders ENGINE = MyISAM                                                     |
|        5 | 0.02476625 | ALTER TABLE orders ENGINE = InnoDB                                                     |
+----------+------------+----------------------------------------------------------------------------------------+
5 rows in set, 1 warning (0.00 sec)
```

## 4. Задача 4
Изучите файл my.cnf в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):

- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб
Приведите в ответе измененный файл my.cnf.

Ответ:
```shell
$ cat /etc/mysql/my.cnf

# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

#
# The MySQL  Server configuration file.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Скорость IO важнее сохранности данных
innodb_flush_log_at_trx_commit  = 2
# Нужна компрессия таблиц для экономии места на диске
innodb_file_per_table = 1
# Размер буффера с незакомиченными транзакциями 1 Мб
innodb_log_buffer_size = 1M
# Буффер кеширования 30% от ОЗУ (не знаю о возможности установить в процентах, по этому хард-параемент)
innodb_buffer_pool_size = = 3068M
# Размер файла логов операций 100 Мб
innodb_log_file_size = 100M

# Custom config should go here
!includedir /etc/mysql/conf.d/
```
