# Домашнее задание к занятию "6.5. Elasticsearch"

## 1. Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ centos:7 как базовый и документацию по установке и запуску Elastcisearch:
- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте push в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути / c хост-машины

Требования к elasticsearch.yml:
- данные path должны сохраняться в /var/lib
- имя ноды должно быть netology_test

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ elasticsearch на запрос пути / в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения
- Далее мы будем работать с данным экземпляром elasticsearch.

Ответ:

elasticsearch.yml
```yaml
cluster.name: ES_cluster
node.name: netology_test
discovery.type: single-node
path.data: /var/lib/data
path.logs: /var/lib/logs
path.repo: /elasticsearch-7.17.0/snapshots
network.host: 0.0.0.0
discovery.seed_hosts: ["127.0.0.1", "[::1]"]
```

Dockerfile
```Dockerfile
FROM centos:7

RUN yum -y install wget \
    && wget -o /dev/null https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.0-linux-x86_64.tar.gz \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.0-linux-x86_64.tar.gz.sha512 \
    && tar -xzf elasticsearch-7.17.0-linux-x86_64.tar.gz

ADD elasticsearch.yml /elasticsearch-7.17.0/config/
ENV JAVA_HOME=/elasticsearch-7.17.0/jdk/
ENV ES_HOME=/elasticsearch-7.17.0

RUN groupadd elasticsearch \
    && useradd -g elasticsearch elasticsearch \
    && mkdir /var/lib/logs \
    && chown elasticsearch:elasticsearch /var/lib/logs \
    && mkdir /var/lib/data \
    && chown elasticsearch:elasticsearch /var/lib/data \
    && chown -R elasticsearch:elasticsearch /elasticsearch-7.17.0 \
    && mkdir /elasticsearch-7.17.0/snapshots \
    && chown elasticsearch:elasticsearch /elasticsearch-7.17.0/snapshots

USER elasticsearch
CMD ["/usr/sbin/init"]
CMD ["/elasticsearch-7.17.0/bin/elasticsearch"]
```

```shell
❯ docker build . -t centos7-elasticsearch7_17_0

[+] Building 765.6s (10/10) FINISHED
 => [internal] load build definition from Dockerfile                                                      0.0s
 => => transferring dockerfile: 1.27kB                                                                    0.0s
 => [internal] load .dockerignore                                                                         0.0s
 => => transferring context: 2B                                                                           0.0s
 => [internal] load metadata for docker.io/library/centos:7                                               3.3s
 => [auth] library/centos:pull token for registry-1.docker.io                                             0.0s
 => [internal] load build context                                                                         0.0s
 => => transferring context: 373B                                                                         0.0s
 => CACHED [1/4] FROM docker.io/library/centos:7@sha256:c73f515d06b0fa07bb18d8202035e739a494ce760aa73129  0.0s
 => [2/4] RUN yum -y install wget     && wget -o /dev/null https://artifacts.elastic.co/downloads/elas  756.3s
 => [3/4] ADD elasticsearch.yml /elasticsearch-7.17.0/config/                                             0.0s
 => [4/4] RUN groupadd elasticsearch     && useradd -g elasticsearch elasticsearch     && mkdir /var/lib  2.0s
 => exporting to image                                                                                    3.8s
 => => exporting layers                                                                                   3.8s
 => => writing image sha256:c74108502b7d5f1cc21e4ca4247e1a44757211038dfcaad37d7f140fe9042944              0.0s
 => => naming to docker.io/library/centos7-elasticsearch7_17_0
```
```shell
❯  docker login

Authenticating with existing credentials...
Login Succeeded
```
```shell
❯  docker tag centos7-elasticsearch7_17_0:latest tasmity/netology-devops:elastic
```
```shell
❯  docker push tasmity/netology-devops:elastic

The push refers to repository [docker.io/tasmity/netology-devops]
c741386096f3: Pushed
c390b655089b: Pushed
b299d2e9afa2: Pushed
174f56854903: Pushed
elastic: digest: sha256:f743b1d4a268415daa0163efd7bc4cd9aadc44c153b197abd5c89eb82f03636e size: 1162
```
[Ссылка на образ](https://hub.docker.com/layers/247121154/tasmity/netology-devops/elastic/images/sha256-f743b1d4a268415daa0163efd7bc4cd9aadc44c153b197abd5c89eb82f03636e?context=repo)
```shell
❯ docker run -d -p=9200:9200 -p=9300:9300 centos7-elasticsearch7_17_0

39d4df2bcf1dc8fb589479d328a6ff3b6a32e1def0832ec8fa69806286e005cc
```
```shell
❯ docker ps

CONTAINER ID   IMAGE                         COMMAND                  CREATED          STATUS          PORTS                                            NAMES
39d4df2bcf1d   centos7-elasticsearch7_17_0   "/elasticsearch-7.17…"   31 seconds ago   Up 30 seconds   0.0.0.0:9200->9200/tcp, 0.0.0.0:9300->9300/tcp   agitated_hertz
```
```shell
❯ curl -X GET http://localhost:9200

{
  "name" : "netology_test",
  "cluster_name" : "ES_cluster",
  "cluster_uuid" : "gwOepRPZSauDE8Hm5meRKw",
  "version" : {
    "number" : "7.17.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "bee86328705acaa9a6daede7140defd4d9ec56bd",
    "build_date" : "2022-01-28T08:36:04.875279988Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```
## 2. Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с документацией и добавьте в elasticsearch 3 индекса, в соответствии со таблицей:

| Имя |	Количество реплик |	Количество шард |
|-----|-------------------|-----------------|
|ind-1|	0	              |1                |
|ind-2|	1                 |2                |
|ind-3|	2	              |4                |

```shell
❯ curl -X PUT http://localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 0,  "number_of_shards": 1 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}%

❯ curl -X PUT http://localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 1,  "number_of_shards": 2 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}

❯ curl -X PUT http://localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 2,  "number_of_shards": 4 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"}%
```

Получите список индексов и их статусов, используя API и приведите в ответе на задание.
```shell
❯ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases WFtVNycLTzuJia0OzE3EDA   1   0         40            0       38mb           38mb
green  open   ind-1            5O-cBHn_SjCWFun9-450LA   1   0          0            0       226b           226b
yellow open   ind-3            G2J2Q07RS-WySyGvp2qVsg   4   2          0            0       904b           904b
yellow open   ind-2            NV5-5lqkRDKJ1OvauBLXnw   2   1          0            0       452b           452b
```
```shell
❯ curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "ES_cluster",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}

❯ curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'
{
  "cluster_name" : "ES_cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}

❯ curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty'
{
  "cluster_name" : "ES_cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
```
Получите состояние кластера elasticsearch, используя API.
```shell
❯ curl -X GET 'http://localhost:9200/_cluster/health/?pretty=true'
{
  "cluster_name" : "ES_cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
```
Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

[В связи с тем, что у нас одна нода.](https://cdnnow.ru/blog/esgreen/#:%7E:text=%D0%9F%D0%BE%D1%87%D0%B5%D0%BC%D1%83%20%D0%BE%D1%82%D0%B4%D0%B5%D0%BB%D1%8C%D0%BD%D1%8B%D0%B9%20%D1%81%D0%B5%D1%80%D0%B2%D0%B5%D1%80%20%D0%B1%D1%83%D0%B4%D0%B5%D1%82%20%D0%BF%D0%BE,%D1%83%D0%B7%D0%BB%D0%BE%D0%B2%2C%20%E2%80%9Cnodes%E2%80%9D:~:text=%D0%9F%D0%BE%D1%87%D0%B5%D0%BC%D1%83%20%D0%BE%D1%82%D0%B4%D0%B5%D0%BB%D1%8C%D0%BD%D1%8B%D0%B9%20%D1%81%D0%B5%D1%80%D0%B2%D0%B5%D1%80%20%D0%B1%D1%83%D0%B4%D0%B5%D1%82%20%D0%BF%D0%BE%20%D1%83%D0%BC%D0%BE%D0%BB%D1%87%D0%B0%D0%BD%D0%B8%D1%8E%20%D0%B6%D1%91%D0%BB%D1%82%D1%8B%D0%BC%3F)

> В системе из одного сервера ES хранит на нём все “primary shards”, но создавать “replica shards” такой системе будет негде.

Удалите все индексы.
```shell
❯ curl -X DELETE 'http://localhost:9200/ind-1?pretty'
{
  "acknowledged" : true
}

❯ curl -X DELETE 'http://localhost:9200/ind-2?pretty'
{
  "acknowledged" : true
}

❯ curl -X DELETE 'http://localhost:9200/ind-3?pretty'
{
  "acknowledged" : true
}
```
```shell
❯ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases WFtVNycLTzuJia0OzE3EDA   1   0         40            0       38mb           38mb
```
Важно

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард, иначе возможна потеря
данных индексов, вплоть до полной, при деградации системы.

## 3. Задача 3

В данном задании вы научитесь:

- создавать бэкапы данных
- восстанавливать индексы из бэкапов

```
Для выполнения этого задания пришлось добватьв в elasticsearch.yml:
action.destructive_requires_name: false
xpack.security.enabled: false
ingest.geoip.downloader.enabled: false
и перезапустить elasticsearch
```
elasticsearch.yml
```yaml
cluster.name: ES_cluster
node.name: netology_test
discovery.type: single-node
path.data: /var/lib/data
path.logs: /var/lib/logs
path.repo: /elasticsearch-7.17.0/snapshots
network.host: 0.0.0.0
discovery.seed_hosts: ["127.0.0.1", "[::1]"]
action.destructive_requires_name: false
xpack.security.enabled: false
ingest.geoip.downloader.enabled: false
```

Создайте директорию {путь до корневой директории с elasticsearch в образе}/snapshots.

Используя API зарегистрируйте данную директорию как snapshot repository c именем netology_backup.

Приведите в ответе запрос API и результат вызова API для создания репозитория.
```shell
❯ curl -X POST localhost:9200/_snapshot/netology_backup\?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/elasticsearch-7.17.0/snapshots" }}'
{
  "acknowledged" : true
}
```
Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.
```shell
❯ curl -X PUT http://localhost:9200/test -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 0, "number_of_shards": 1 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}%

❯ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  zdv8a6cORwWzsA3hYEUtZQ   1   0          0            0       226b           226b
```
Создайте snapshot состояния кластера elasticsearch.
```shell
❯ curl -X PUT http://localhost:9200/_snapshot/netology_backup/elasticsearch\?wait_for_completion\=true

{"snapshot":{"snapshot":"elasticsearch","uuid":"-EqqBwG9TdmsrT_hOO82kQ","repository":"netology_backup","version_id":7170099,"version":"7.17.0","indices":["test"],"data_streams":[],"include_global_state":true,"state":"SUCCESS","start_time":"2022-07-04T13:55:52.303Z","start_time_in_millis":1656942952303,"end_time":"2022-07-04T13:55:52.303Z","end_time_in_millis":1656942952303,"duration_in_millis":0,"failures":[],"shards":{"total":1,"failed":0,"successful":1},"feature_states":[]}}
```
Приведите в ответе список файлов в директории со snapshotами.
```shell
sh-4.2$ ls -l

total 48
-rw-r--r-- 1 elasticsearch elasticsearch   590 Jul  4 13:55 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Jul  4 13:55 index.latest
drwxr-xr-x 3 elasticsearch elasticsearch  4096 Jul  4 13:55 indices
-rw-r--r-- 1 elasticsearch elasticsearch 28358 Jul  4 13:55 meta--EqqBwG9TdmsrT_hOO82kQ.dat
-rw-r--r-- 1 elasticsearch elasticsearch   353 Jul  4 13:55 snap--EqqBwG9TdmsrT_hOO82kQ.dat
```
Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.
```shell
❯ curl -X DELETE 'http://localhost:9200/test?pretty'
{
  "acknowledged" : true
}

❯ curl -X PUT http://localhost:9200/test-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 0, "number_of_shards": 1 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test-2"}
```
```shell
❯ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 Cmkq43gTQIeuAi7UeDDOAQ   1   0          0            0       226b           226b
```
Восстановите состояние кластера elasticsearch из snapshot, созданного ранее.

Приведите в ответе запрос к API восстановления и итоговый список индексов.
```shell
❯ curl -X POST localhost:9200/_snapshot/netology_backup/elasticsearch/_restore\?wait_for_completion=true
{"snapshot":{"snapshot":"elasticsearch","indices":["test"],"shards":{"total":1,"failed":0,"successful":1}}}%
```
```shell
❯ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 Cmkq43gTQIeuAi7UeDDOAQ   1   0          0            0       226b           226b
green  open   test   wH92LAobRxmJLJQ71uBVAw   1   0          0            0       226b           226b
```
Подсказки:

- возможно вам понадобится доработать elasticsearch.yml в части директивы path.repo и перезапустить elasticsearch

