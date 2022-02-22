# Домашнее задание к занятию "6.2. SQL"

## 1. Задача 1
Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут 
складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

Ответ:

docker-compose.yml
```yaml
version: "3.8"
services:

  db:
    image: postgres:12-alpine
    container_name: postgresSQL
    restart: always
    environment:
      POSTGRES_PASSWORD: postgre
    ports:
      - 5432:5432
    volumes:
      - bd:/var/lib/postgresql/data
      - backup:/var/tmp

  adminer:
    image: adminer
    restart: always
    ports:
      - 8080:8080

volumes:
  bd:
  backup:
```
```shell
❯ docker-compose up -d

Creating network "postgre_default" with the default driver
Creating volume "postgre_bd" with default driver
Creating volume "postgre_backup" with default driver
Pulling db (postgres:12-alpine)...
12-alpine: Pulling from library/postgres
59bf1c3509f3: Already exists
c50e01d57241: Pull complete
a0646b0f1ead: Pull complete
c4cf156c3ca3: Pull complete
51ed07340794: Pull complete
7c158e4ed48f: Pull complete
d88a6b4803ae: Pull complete
372cd963b4bd: Pull complete
Digest: sha256:b5da30d2ba744fe890fa18695e201cea1366491be287a74b8d7709da8a5b9304
Status: Downloaded newer image for postgres:12-alpine
Pulling adminer (adminer:)...
latest: Pulling from library/adminer
59bf1c3509f3: Already exists
7c7da25b2876: Pull complete
2bc599114627: Pull complete
927a0b37a45a: Pull complete
d47c8877a66a: Pull complete
8f3c2cc92d11: Pull complete
05db1cf8b390: Pull complete
d1140d7e4ba0: Pull complete
887b804c743a: Pull complete
17413dba47a0: Pull complete
e18e50dd401d: Pull complete
111cd0fb20a3: Pull complete
2e9e829195f7: Pull complete
50d72130afd0: Pull complete
6003b0cb4252: Pull complete
Digest: sha256:bbecfea5b1bafbe2057ce53996463f349daaa01198215e14a498a4a9c428f0ff
Status: Downloaded newer image for adminer:latest
Creating postgre_adminer_1 ... done
Creating postgresSQL       ... done
```
```shell
❯ docker ps
CONTAINER ID   IMAGE                COMMAND                  CREATED         STATUS         PORTS                    NAMES
68f08529a6d6   adminer              "entrypoint.sh docke…"   2 minutes ago   Up 2 minutes   0.0.0.0:8080->8080/tcp   postgre_adminer_1
304d68fbb755   postgres:12-alpine   "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes   0.0.0.0:5432->5432/tcp   postgresSQL
```
```shell
❯ docker exec -it 304d68fbb755 sh
/ #
```
```shell
# su - postgres
304d68fbb755:~$
```
```shell
304d68fbb755:~$ psql
psql (12.10)
Type "help" for help.

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

postgres=#
```
## 2. Задача 2
В БД из задачи 1:
- создайте пользователя test-admin-user и БД test_db

Ответ:
```sql
postgres=# CREATE USER test_admin_user WITH PASSWORD 'kOjzgsF33';
CREATE ROLE

postgres=# CREATE DATABASE test_db;
CREATE DATABASE
```
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

 Ответ:
```sql
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  наименование TEXT,
  цена INT
);

CREATE TABLE clients
(
    id SERIAL PRIMARY KEY,
    фамилия TEXT,
    "Страна проживания" TEXT,
    заказ INTEGER,
    FOREIGN KEY (заказ) REFERENCES orders (id)
);

test_db=# CREATE INDEX ON clients ("Страна проживания");
```

- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db

Ответ:
```sql
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO test_admin_user;

GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO test_admin_user;
```
- создайте пользователя test-simple-user

Ответ:
```sql
CREATE USER test_simple_user WITH PASSWORD 'CCaaSS!!22##';
```
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Ответ:
```sql
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO test_simple_user;
```

Приведите:
- итоговый список БД после выполнения пунктов выше,

Ответ:
```sql
test_db=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)
```
- описание таблиц (describe)

Ответ:
```sql
test_db=# \d orders
                               Table "public.orders"
    Column    |  Type   | Collation | Nullable |              Default
--------------+---------+-----------+----------+------------------------------------
 id           | integer |           | not null | nextval('orders_id_seq'::regclass)
 наименование | text    |           |          |
 цена         | integer |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
    
    
test_db=# \d clients
                                  Table "public.clients"
      Column       |  Type   | Collation | Nullable |               Default
-------------------+---------+-----------+----------+-------------------------------------
 id                | integer |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | text    |           |          |
 Страна проживания | text    |           |          |
 заказ             | integer |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "clients_Страна проживания_idx" btree ("Страна проживания")
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
```
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

Ответ:
```sql
SELECT * from information_schema.table_privileges WHERE grantee LIKE 'test%';
```
- список пользователей с правами над таблицами test_db

Ответ:
```sql
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | test_admin_user  | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test_admin_user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test_admin_user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
 postgres | test_simple_user | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test_simple_user | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test_simple_user | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test_simple_user | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test_simple_user | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test_simple_user | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test_simple_user | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test_simple_user | test_db       | public       | clients    | DELETE         | NO           | NO
(22 rows)
```

## 3. Задача 3
Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

| Наименование | цена |
|:--|:--|
| Шоколад |	10 |
| Принтер |	3000 |
| Книга | 500 |
| Монитор |	7000 |
| Гитара | 4000 |

Таблица clients

| ФИО |	Страна проживания |
|:--|:--|
| Иванов Иван Иванович |	USA |
| Петров Петр Петрович |	Canada |
| Иоганн Себастьян Бах |	Japan |
| Ронни Джеймс Дио |	Russia |
| Ritchie Blackmore	| Russia |

Ответ:
```sql
INSERT INTO orders (наименование, цена)
  VALUES
  ('Шоколад', 10),
  ('Принтер', 3000),
  ('Книга',   500),
  ('Монитор', 7000),
  ('Гитара',  4000);
  
INSERT INTO clients (фамилия, "Страна проживания")
  VALUES
  ('Иванов Иван Иванович', 'USA'),
  ('Петров Петр Петрович', 'Canada'),
  ('Иоганн Себастьян Бах', 'Japan'),
  ('Ронни Джеймс Дио', 'Russia'),
  ('Ritchie Blackmore', 'Russia');
```
Используя SQL синтаксис:

- вычислите количество записей для каждой таблицы
- приведите в ответе:
     - запросы
     - результаты их выполнения.

Ответ:
```sql
test_db=# SELECT COUNT(id) FROM orders;
 count
-------
     5
(1 row)

test_db=# SELECT COUNT(id) FROM clients;
 count
-------
     5
(1 row)
```


## 4. Задача 4
Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

| ФИО |	Заказ |
|:--|:--|
| Иванов Иван Иванович |	Книга |
| Петров Петр Петрович |	Монитор |
| Иоганн Себастьян Бах |	Гитара |

Приведите SQL-запросы для выполнения данных операций.

Ответ:
```sqi
UPDATE clients SET заказ=3 WHERE id=1;
UPDATE clients SET заказ=4 WHERE id=2;
UPDATE clients SET заказ=5 WHERE id=3;

```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также
вывод данного запроса.

Ответ:
```sqi
test_db=# SELECT * FROM clients WHERE заказ IS NOT NULL;
 id |       фамилия        | Страна проживания | заказ
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(3 rows)
```
Подсказк - используйте директиву UPDATE.


## 5. Задача 5
Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи
4 (используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

Ответ:
```sql
test_db=# EXPLAIN SELECT * FROM clients WHERE заказ IS NOT NULL;
                        QUERY PLAN
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
   Filter: ("заказ" IS NOT NULL)
(2 rows)
```
- cost=0.00 - приблизительная стоимость запуска. Это время, которое проходит, прежде чем начнётся этап вывода данных, например для сортирующего узла это время сортировки.
- 18.10 - приблизительная общая стоимость. Она вычисляется в предположении, что узел плана выполняется до конца, то есть возвращает все доступные строки. На практике родительский узел может досрочно прекратить чтение строк дочернего (см. приведённый ниже пример с LIMIT).
- rows=806 - ожидаемое число строк, которое должен вывести этот узел плана. При этом так же предполагается, что узел выполняется до конца.
- width=72 - ожидаемый средний размер строк, выводимых этим узлом плана (в байтах).

## 6. Задача 6
Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов
(см. Задачу 1).

Ответ:
```shell
304d68fbb755:~$ pg_dump -U postgres -h localhost -p 5432 -x --format=custom --clean --create -f /var/tmp/test_db.dump test_db

304d68fbb755:~$ ls /var/tmp/
test_db.dump
```

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Ответ:
```shell
❯ docker ps
CONTAINER ID   IMAGE                COMMAND                  CREATED             STATUS             PORTS                    NAMES
68f08529a6d6   adminer              "entrypoint.sh docke…"   About an hour ago   Up About an hour   0.0.0.0:8080->8080/tcp   postgre_adminer_1
304d68fbb755   postgres:12-alpine   "docker-entrypoint.s…"   About an hour ago   Up About an hour   0.0.0.0:5432->5432/tcp   postgresSQL

❯ docker stop 304d68fbb755
304d68fbb755
❯ docker rm 304d68fbb755
304d68fbb755
❯ docker stop 68f08529a6d6
68f08529a6d6
❯ docker rm 68f08529a6d6
68f08529a6d6

❯ docker volume ls
DRIVER    VOLUME NAME
local     postgre_backup
local     postgre_bd

❯ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

❯ docker volume rm postgre_bd
postgre_bd

❯ docker volume ls
DRIVER    VOLUME NAME
local     postgre_backup
```

Поднимите новый пустой контейнер с PostgreSQL.

Ответ:
```shell
❯ docker-compose up -d
Creating volume "postgre_bd" with default driver
Creating postgresSQL       ... done
Creating postgre_adminer_1 ... done

❯ docker ps
CONTAINER ID   IMAGE                COMMAND                  CREATED              STATUS              PORTS                    NAMES
f6321966947a   adminer              "entrypoint.sh docke…"   About a minute ago   Up About a minute   0.0.0.0:8080->8080/tcp   postgre_adminer_1
2d051c5447d6   postgres:12-alpine   "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:5432->5432/tcp   postgresSQL

❯ docker exec -it 2d051c5447d6 sh
```
```shell
/ # su - postgres

2d051c5447d6:~$ psql
psql (12.10)
Type "help" for help.

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
Восстановите БД test_db в новом контейнере.

Ответ:
```shell
2d051c5447d6:~$ pg_restore -U postgres -C -d postgres /var/tmp/test_db.dump

2d051c5447d6:~$ psql
psql (12.10)
Type "help" for help.

postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)

postgres=# \c test_db
You are now connected to database "test_db" as user "postgres".

test_db=# SELECT * FROM orders;
 id | наименование | цена
----+--------------+------
  1 | Шоколад      |   10
  2 | Принтер      | 3000
  3 | Книга        |  500
  4 | Монитор      | 7000
  5 | Гитара       | 4000
(5 rows)

test_db=# SELECT * FROM clients;
 id |       фамилия        | Страна проживания | заказ
----+----------------------+-------------------+-------
  4 | Ронни Джеймс Дио     | Russia            |
  5 | Ritchie Blackmore    | Russia            |
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(5 rows)
```
Приведите список операций, который вы применяли для бэкапа данных и восстановления.
