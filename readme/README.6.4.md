# Домашнее задание к занятию "6.4. PostgreSQL"

## 1. Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Ответ:
```shell
❯ vi docker-compose.yml
```
```yaml
version: "3.8"

services:

  db:
    image: postgres:13.6-alpine
    restart: always
    environment:
      POSTGRES_PASSWORD: kOjzgsF
    volumes:
      - db:/var/lib/postgresql/data
    ports:
      - 5432:5432

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

Creating network "posgre2_default" with the default driver
Creating volume "posgre2_db" with default driver
Pulling db (postgres:13.6-alpine)...
13.6-alpine: Pulling from library/postgres
df9b9388f04a: Pull complete
7902437d3a12: Pull complete
709e2267bc98: Pull complete
5eec3cc5f8bc: Pull complete
9caf1365e403: Pull complete
c4dbc2044e67: Pull complete
db3eb34443f3: Pull complete
01a8f18ebd09: Pull complete
Digest: sha256:8522c9920d88bc95f6d19d054d7a8085745d0e4511ff422db8070ebd94a79544
Status: Downloaded newer image for postgres:13.6-alpine
Creating posgre2_db_1      ... done
Creating posgre2_adminer_1 ... done
```
```shell
❯ docker ps

CONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS          PORTS                    NAMES
f20f9194c50a   adminer                "entrypoint.sh docke…"   48 seconds ago   Up 47 seconds   0.0.0.0:8080->8080/tcp   posgre2_adminer_1
d2d96ab88509   postgres:13.6-alpine   "docker-entrypoint.s…"   48 seconds ago   Up 47 seconds   0.0.0.0:5432->5432/tcp   posgre2_db_1
```
```shell
❯ docker exec -it d2d96ab88509 bash

bash-5.1#
```

Подключитесь к БД PostgreSQL используя psql.

Ответ:
```shell
bash-5.1# su - postgres

d2d96ab88509:~$ psql
psql (13.6)
Type "help" for help.

postgres=#
```

Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам.

Найдите и приведите управляющие команды для:
- вывода списка БД

Ответ:
```shell
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)
```
- подключения к БД

Ответ:
```shell
postgres-# \c postgres
You are now connected to database "postgres" as user "postgres".
```
- вывода списка таблиц

Ответ:
```shell
postgres-# \dt
Did not find any relations.

# Сейчас у нас нет таблиц
```
- вывода описания содержимого таблиц

Ответ:
```shell
postgres-# \d <table_name>

# Сейчас у нас нет таблиц
```
- выхода из psql

Ответ:
```shell
postgres-# \q
d2d96ab88509:~$
```

## 2. Задача 2

Используя psql создайте БД test_database.

Ответ:
```shell
d2d96ab88509:~$ psql
psql (13.6)
Type "help" for help.

postgres=#
```
```shell
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
```

Изучите бэкап БД.

Восстановите бэкап БД в test_database.
```shell
# на локальной машине
❯ docker cp test_dump.sql d2d96ab88509:/var/tmp/test_dump.sql
```
```shell
# в контейнере
d2d96ab88509:~$ psql -d test_database -f /var/tmp/test_dump.sql
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
```
Перейдите в управляющую консоль psql внутри контейнера.

Ответ:
```shell
d2d96ab88509:~$ psql
psql (13.6)
Type "help" for help.

postgres=#
```
Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Ответ:
```shell
postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=#

test_database=# \dt
         List of relations
 Schema |  Name  | Type  |  Owner
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)

test_database=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```
Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.

Приведите в ответе команду, которую вы использовали для вычисления и полученный результат.

Ответ:
```SQL
SELECT attname FROM pg_stats WHERE tablename='orders' AND avg_width = (SELECT MAX(avg_width) FROM pg_stats WHERE tablename='orders');
```
```shell
test_database=# SELECT attname FROM pg_stats WHERE tablename='orders' AND avg_width = (SELECT MAX(avg_width) FROM pg_stats WHERE tablename='orders');
 attname
---------
 title
(1 row)
```

## 3. Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает
долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение таблицы на 2
(шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Ответ:
```shell
START TRANSACTION;
CREATE TABLE orders_1 (LIKE orders);
INSERT INTO orders_1 SELECT * FROM orders WHERE price >499;
DELETE FROM orders WHERE price >499;
CREATE TABLE orders_2 (LIKE orders);
INSERT INTO orders_2 SELECT * FROM orders WHERE price <=499;
DELETE FROM orders WHERE price <=499;
COMMIT;
```
```shell
test_database-# \dt
          List of relations
 Schema |   Name   | Type  |  Owner
--------+----------+-------+----------
 public | orders   | table | postgres
 public | orders_1 | table | postgres
 public | orders_2 | table | postgres

test_database=# SELECT * FROM orders_1;
 id |       title        | price
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)

test_database=# SELECT * FROM orders_2;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)
```
Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Ответ:
> PostgreSQL предоставляет возможность указать, как разбить таблицу на части, называемые секциями. Разделённая таким
> способом таблица называется секционированной таблицей. Указание секционирования состоит из определения метода
> секционирования и списка столбцов или выражений, которые будут составлять ключ разбиения.
> 
> Преобразовать обычную таблицу в секционированную и наоборот нельзя. Данное требование надо было учитывать при создании
> таблицы.
```shell
CREATE TABLE orders (
    id integer NOT NULL,
    title character varying(80),
    price integer DEFAULT 0 # дефолтовое значение, чтоб поле не было null
)
PARTITION BY RANGE (price);

CREATE TABLE orders_1
    PARTITION OF orders
    FOR VALUES FROM (499) TO (1000);
    
CREATE TABLE orders_2
    PARTITION OF orders
    FOR VALUES FROM (0) TO (499);

```
## 4. Задача 4
Используя утилиту pg_dump создайте бекап БД test_database.

Ответ:
```shell
d2d96ab88509:~$ pg_dump -f /var/tmp/test_backup.sql -h db -p 5432 -U postgres test_database
Password:
```
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?

Ответ:
> Ограничения уникальности гарантируют, что данные в определённом столбце или группе столбцов уникальны среди всех
> строк таблицы.
```shell
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL, 
    price integer DEFAULT 0,
    UNIQUE (title)
);
```