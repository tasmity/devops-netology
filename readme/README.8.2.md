# Домашнее задание к занятию "08.02 Работа с Playbook"

## Подготовка к выполнению

1. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
2. Скачайте [playbook](https://github.com/netology-code/mnt-homeworks/blob/master/08-ansible-02-playbook/playbook) из репозитория с домашним заданием и перенесите его в свой репозиторий.
3. Подготовьте хосты в соответствии с группами из предподготовленного playbook.
4. Скачайте дистрибутив [java](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) и положите его в директорию playbook/files/.

## Основная часть

1. Приготовьте свой собственный inventory файл prod.yml.

   ```yml
    elasticsearch:
      hosts:
        centos7:
          ansible_connection: docker
    ```

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает kibana.
3. При создании tasks рекомендую использовать модули: get_url, template, unarchive, file.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, сгенерировать конфигурацию с параметрами.

    ```yml
    ---
    - name: Install Java
      hosts: all
      tasks:
        - name: Set facts for Java 11 vars
        ansible.builtin.set_fact:
            java_home: "/opt/jdk/{{ java_jdk_version }}"
        tags: java
        - name: Upload .tar.gz file containing binaries from local storage
        ansible.builtin.copy:
            src: "{{ java_oracle_jdk_package }}"
            dest: "/tmp/jdk-{{ java_jdk_version }}.tar.gz"
            mode: 0644
        register: download_java_binaries
        until: download_java_binaries is succeeded
        tags: java
        - name: Ensure installation dir exists
        become: true
        ansible.builtin.file:
            state: directory
            path: "{{ java_home }}"
            mode: 0644
        tags: java
        - name: Extract java in the installation directory
        become: true
        ansible.builtin.unarchive:
            copy: false
            src: "/tmp/jdk-{{ java_jdk_version }}.tar.gz"
            dest: "{{ java_home }}"
            extra_opts: [--strip-components=1]
            creates: "{{ java_home }}/bin/java"
        tags:
            - java
        - name: Export environment variables
        become: true
        ansible.builtin.template:
            src: jdk.sh.j2
            dest: /etc/profile.d/jdk.sh
            mode: 0755
        tags: java
    - name: Install Elasticsearch
      hosts: elasticsearch
      tasks:
      - name: Upload tar.gz Elasticsearch from remote URL
        ansible.builtin.get_url:
            url: "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-{{ elastic_version }}-linux-x86_64.tar.gz"
            dest: "/tmp/elasticsearch-{{ elastic_version }}-linux-x86_64.tar.gz"
            mode: 0755
            timeout: 60
            force: true
            validate_certs: false
        register: get_elastic
        until: get_elastic is succeeded
        tags: elastic
      - name: Create directrory for Elasticsearch
        ansible.builtin.file:
            state: directory
            path: "{{ elastic_home }}"
            mode: 0644
        tags: elastic
      - name: Extract Elasticsearch in the installation directory
        become: true
        ansible.builtin.unarchive:
            copy: false
            src: "/tmp/elasticsearch-{{ elastic_version }}-linux-x86_64.tar.gz"
            dest: "{{ elastic_home }}"
            extra_opts: [--strip-components=1]
            creates: "{{ elastic_home }}/bin/elasticsearch"
        tags:
            - elastic
       - name: Set environment Elastic
         become: true
         ansible.builtin.template:
            src: templates/elk.sh.j2
            dest: /etc/profile.d/elk.sh
            mode: 0755
        tags: elastic
    - name: Install kibana
      hosts: elasticsearch
      tasks:
      - name: Upload tar.gz Kibana from remote URL
        ansible.builtin.get_url:
            url: "https://artifacts.elastic.co/downloads/kibana/https://artifacts.elastic.co/downloads/kibana/kibana-8.3.2-linux-x86_64.tar.gz"
            dest: "/tmp/kibana-8.3.2-linux-x86_64.tar.gz"
            mode: 0755
            timeout: 60
            force: true
            validate_certs: false
        register: get_kibana
        until: get_kibana is succeeded
        tags: kibana
      - name: Create directrory for Kibana
        ansible.builtin.file:
            state: directory
            path: "{{ kibana_home }}"
            mode: 0644
        tags: kibana
      - name: Extract Kibana in the installation directory
        become: true
        ansible.builtin.unarchive:
            copy: false
            src: "/tmp/kibana-8.3.2-linux-x86_64.tar.gz"
            dest: "{{ kibana_home }}"
            extra_opts: [--strip-components=1]
        tags:
            - kibana
      - name: Set parameters Kibana
        become: true
        ansible.builtin.template:
            src: templates/kibana.yml.j2
            dest: /etc/kibana/kibana.yml
            mode: 0644
        tags: kibana

    ```

5. Запустите ansible-lint site.yml и исправьте ошибки, если они есть.

    ```shell
    ❯ ansible-lint site.yml
    WARNING: PATH altered to include /usr/local/Cellar/ansible-lint/6.3.0/libexec/bin
    WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
    ```

6. Попробуйте запустить playbook на этом окружении с флагом --check.

    ```shell
    ❯ ansible-playbook -i inventory/prod.yml site.yml --check

    PLAY [Install Java] ******************************************************************************************************************************************************

    TASK [Gathering Facts] ***************************************************************************************************************************************************
    ok: [centos7]

    TASK [Set facts for Java 17 vars] ****************************************************************************************************************************************
    ok: [centos7]

    TASK [Upload .tar.gz file containing binaries from local storage] ********************************************************************************************************
    changed: [centos7]

    TASK [Ensure installation dir exists] ************************************************************************************************************************************
    changed: [centos7]

    TASK [Extract java in the installation directory] ************************************************************************************************************************
    fatal: [centos7]: FAILED! => {"changed": false, "msg": "dest '/opt/jdk/17.0.4' must be an existing dir"}

    PLAY RECAP ***************************************************************************************************************************************************************
    centos7                    : ok=4    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
    ```

7. Запустите playbook на prod.yml окружении с флагом --diff. Убедитесь, что изменения на системе произведены.

    ```shell
    ❯ ansible-playbook -i inventory/prod.yml site.yml --diff

    PLAY [Install Java] ******************************************************************************************************************************************************

    TASK [Gathering Facts] ***************************************************************************************************************************************************
    ok: [centos7]

    TASK [Set facts for Java 17 vars] ****************************************************************************************************************************************
    ok: [centos7]

    TASK [Upload .tar.gz file containing binaries from local storage] ********************************************************************************************************
    ok: [centos7]

    TASK [Ensure installation dir exists] ************************************************************************************************************************************
    --- before
    +++ after
    @@ -1,5 +1,5 @@
    {
    -    "mode": "0755",
    +    "mode": "0644",
        "path": "/opt/jdk/17.0.4",
    -    "state": "absent"
    +    "state": "directory"
    }

    changed: [centos7]

    TASK [Extract java in the installation directory] ************************************************************************************************************************
    changed: [centos7]

    TASK [Export environment variables] **************************************************************************************************************************************
    --- before
    +++ after: /Users/tasmity/.ansible/tmp/ansible-local-82737mnzdg00n/tmp_5a40phz/jdk.sh.j2
    @@ -0,0 +1,5 @@
    +# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
    +#!/usr/bin/env bash
    +
    +export JAVA_HOME=/opt/jdk/17.0.4
    +export PATH=$PATH:$JAVA_HOME/bin
    \ No newline at end of file

    changed: [centos7]

    PLAY [Install Elasticsearch] *********************************************************************************************************************************************

    TASK [Gathering Facts] ***************************************************************************************************************************************************
    ok: [centos7]

    TASK [Upload tar.gz Elasticsearch from remote URL] ***********************************************************************************************************************
    ok: [centos7]

    TASK [Create directrory for Elasticsearch] *******************************************************************************************************************************
    --- before
    +++ after
    @@ -1,5 +1,5 @@
    {
    -    "mode": "0755",
    +    "mode": "0644",
        "path": "/opt/elastic/7.10.1",
    -    "state": "absent"
    +    "state": "directory"
    }

    changed: [centos7]

    TASK [Extract Elasticsearch in the installation directory] ***************************************************************************************************************
    changed: [centos7]

    TASK [Set environment Elastic] *******************************************************************************************************************************************
    --- before
    +++ after: /Users/tasmity/.ansible/tmp/ansible-local-82737mnzdg00n/tmpqtujzo41/elk.sh.j2
    @@ -0,0 +1,5 @@
    +# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
    +#!/usr/bin/env bash
    +
    +export ES_HOME=/opt/elastic/7.10.1
    +export PATH=$PATH:$ES_HOME/bin
    \ No newline at end of file

    changed: [centos7]

    PLAY [Install kibana] ****************************************************************************************************************************************************

    TASK [Gathering Facts] ***************************************************************************************************************************************************
    ok: [centos7]

    TASK [Upload tar.gz Kibana from remote URL] ******************************************************************************************************************************
    ok: [centos7]

    TASK [Create directrory for Kibana] **************************************************************************************************************************************
    --- before
    +++ after
    @@ -1,5 +1,5 @@
    {
    -    "mode": "0755",
    +    "mode": "0644",
        "path": "/opt/kibana",
    -    "state": "absent"
    +    "state": "directory"
    }

    changed: [centos7]

    TASK [Extract Kibana in the installation directory] **********************************************************************************************************************
    changed: [centos7]

    TASK [Create parameters directrory for Kibana] ***************************************************************************************************************************
    --- before
    +++ after
    @@ -1,5 +1,5 @@
    {
    -    "mode": "0755",
    +    "mode": "0644",
        "path": "/etc/kibana",
    -    "state": "absent"
    +    "state": "directory"
    }

    changed: [centos7]

    TASK [Set parameters Kibana] *********************************************************************************************************************************************
    --- before
    +++ after: /Users/tasmity/.ansible/tmp/ansible-local-82737mnzdg00n/tmpj28oup9r/kibana.yml.j2
    @@ -0,0 +1,116 @@
    +# Kibana is served by a back end server. This setting specifies the port to use.
    +#server.port: 5601
    +
    +# Specifies the address to which the Kibana server will bind. IP addresses and host names are both valid values.
    +# The default is 'localhost', which usually means remote machines will not be able to connect.
    +# To allow connections from remote users, set this parameter to a non-loopback address.
    +server.host: "0.0.0.0"
    +
    +#xpack.monitoring.ui.container.elasticsearch.enabled: true
    +
    +# Enables you to specify a path to mount Kibana at if you are running behind a proxy.
    +# Use the `server.rewriteBasePath` setting to tell Kibana if it should remove the basePath
    +# from requests it receives, and to prevent a deprecation warning at startup.
    +# This setting cannot end in a slash.
    +#server.basePath: ""
    +
    +# Specifies whether Kibana should rewrite requests that are prefixed with
    +# `server.basePath` or require that they are rewritten by your reverse proxy.
    +# This setting was effectively always `false` before Kibana 6.3 and will
    +# default to `true` starting in Kibana 7.0.
    +#server.rewriteBasePath: false
    +
    +# The maximum payload size in bytes for incoming server requests.
    +#server.maxPayloadBytes: 1048576
    +
    +# The Kibana server's name.  This is used for display purposes.
    +#server.name: "kibana-nomenclature"
    +
    +# The URLs of the Elasticsearch instances to use for all your queries.
    +elasticsearch.hosts: ["http://localhost:9200"]
    +
    +# When this setting's value is true Kibana uses the hostname specified in the server.host
    +# setting. When the value of this setting is false, Kibana uses the hostname of the host
    +# that connects to this Kibana instance.
    +#elasticsearch.preserveHost: true
    +
    +# Kibana uses an index in Elasticsearch to store saved searches, visualizations and
    +# dashboards. Kibana creates a new index if the index doesn't already exist.
    +#kibana.index: ".kibana"
    +
    +# The default application to load.
    +#kibana.defaultAppId: "home"
    +
    +# If your Elasticsearch is protected with basic authentication, these settings provide
    +# the username and password that the Kibana server uses to perform maintenance on the Kibana
    +# index at startup. Your Kibana users still need to authenticate with Elasticsearch, which
    +# is proxied through the Kibana server.
    +#elasticsearch.username: "kibana"
    +#elasticsearch.password: "drees2019!"
    +
    +# Enables SSL and paths to the PEM-format SSL certificate and SSL key files, respectively.
    +# These settings enable SSL for outgoing requests from the Kibana server to the browser.
    +#server.ssl.enabled: false
    +#server.ssl.certificate: /path/to/your/server.crt
    +#server.ssl.key: /path/to/your/server.key
    +
    +# Optional settings that provide the paths to the PEM-format SSL certificate and key files.
    +# These files validate that your Elasticsearch backend uses the same key files.
    +#elasticsearch.ssl.certificate: /path/to/your/client.crt
    +#elasticsearch.ssl.key: /path/to/your/client.key
    +
    +# Optional setting that enables you to specify a path to the PEM file for the certificate
    +# authority for your Elasticsearch instance.
    +#elasticsearch.ssl.certificateAuthorities: [ "/path/to/your/CA.pem" ]
    +
    +# To disregard the validity of SSL certificates, change this setting's value to 'none'.
    +#elasticsearch.ssl.verificationMode: full
    +
    +# Time in milliseconds to wait for Elasticsearch to respond to pings. Defaults to the value of
    +# the elasticsearch.requestTimeout setting.
    +#elasticsearch.pingTimeout: 1500
    +
    +# Time in milliseconds to wait for responses from the back end or Elasticsearch. This value
    +# must be a positive integer.
    +#elasticsearch.requestTimeout: 30000
    +
    +# List of Kibana client-side headers to send to Elasticsearch. To send *no* client-side
    +# headers, set this value to [] (an empty list).
    +#elasticsearch.requestHeadersWhitelist: [ authorization ]
    +
    +# Header names and values that are sent to Elasticsearch. Any custom headers cannot be overwritten
    +# by client-side headers, regardless of the elasticsearch.requestHeadersWhitelist configuration.
    +#elasticsearch.customHeaders: {}
    +
    +# Time in milliseconds for Elasticsearch to wait for responses from shards. Set to 0 to disable.
    +#elasticsearch.shardTimeout: 30000
    +
    +# Time in milliseconds to wait for Elasticsearch at Kibana startup before retrying.
    +#elasticsearch.startupTimeout: 5000
    +
    +# Logs queries sent to Elasticsearch. Requires logging.verbose set to true.
    +#elasticsearch.logQueries: false
    +
    +# Specifies the path where Kibana creates the process ID file.
    +#pid.file: /var/run/kibana.pid
    +
    +# Enables you specify a file where Kibana stores log output.
    +#logging.dest: stdout
    +
    +# Set the value of this setting to true to suppress all logging output.
    +#logging.silent: false
    +
    +# Set the value of this setting to true to suppress all logging output other than error messages.
    +#logging.quiet: false
    +
    +# Set the value of this setting to true to log all events, including system usage information
    +# and all requests.
    +#logging.verbose: false
    +
    +# Set the interval in milliseconds to sample system and process performance
    +# metrics. Minimum is 100ms. Defaults to 5000.
    +#ops.interval: 5000
    +
    +# Specifies locale to be used for all localizable strings, dates and number formats.
    +# Supported languages are the following: English - en , by default , Chinese - zh-CN .
    +#i18n.locale: "en"

    changed: [centos7]

    PLAY RECAP ***************************************************************************************************************************************************************
    centos7                    : ok=17   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```

8. Повторно запустите playbook с флагом --diff и убедитесь, что playbook идемпотентен.

    ```shell
    ❯ ansible-playbook -i inventory/prod.yml site.yml --diff

    PLAY [Install Java] ******************************************************************************************************************************************************

    TASK [Gathering Facts] ***************************************************************************************************************************************************
    ok: [centos7]

    TASK [Set facts for Java 17 vars] ****************************************************************************************************************************************
    ok: [centos7]

    TASK [Upload .tar.gz file containing binaries from local storage] ********************************************************************************************************
    ok: [centos7]

    TASK [Ensure installation dir exists] ************************************************************************************************************************************
    ok: [centos7]

    TASK [Extract java in the installation directory] ************************************************************************************************************************
    skipping: [centos7]

    TASK [Export environment variables] **************************************************************************************************************************************
    ok: [centos7]

    PLAY [Install Elasticsearch] *********************************************************************************************************************************************

    TASK [Gathering Facts] ***************************************************************************************************************************************************
    ok: [centos7]

    TASK [Upload tar.gz Elasticsearch from remote URL] ***********************************************************************************************************************
    ok: [centos7]

    TASK [Create directrory for Elasticsearch] *******************************************************************************************************************************
    ok: [centos7]

    TASK [Extract Elasticsearch in the installation directory] ***************************************************************************************************************
    skipping: [centos7]

    TASK [Set environment Elastic] *******************************************************************************************************************************************
    ok: [centos7]

    PLAY [Install kibana] ****************************************************************************************************************************************************

    TASK [Gathering Facts] ***************************************************************************************************************************************************
    ok: [centos7]

    TASK [Upload tar.gz Kibana from remote URL] ******************************************************************************************************************************
    changed: [centos7]

    TASK [Create directrory for Kibana] **************************************************************************************************************************************
    ok: [centos7]

    TASK [Extract Kibana in the installation directory] **********************************************************************************************************************
    ok: [centos7]

    TASK [Create parameters directrory for Kibana] ***************************************************************************************************************************
    ok: [centos7]

    TASK [Set parameters Kibana] *********************************************************************************************************************************************
    ok: [centos7]

    PLAY RECAP ***************************************************************************************************************************************************************
    centos7                    : ok=15   changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
    ```

9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

    > ## Что делает playbook
    >
    > ### Плейбук развернёт на хосте следующее ПО
    >
    > - JDK 17.0.4
    > - Elasticsearch 7.10.1
    > - Kibana 8.3.2
    >
    > ## Содержание директории
    >
    > - site.yml - сам playbook
    > - inventory/prod.yml - параметры хоста
    > - group-vars, содержит переменные в файлах vars.yml для всех хостов и для хостов elasticsearch (в соответствующих директориях)
    > - templates, содержит шаблоны Jinja2
    >
    > ## Модули используемые в playbook
    >
    > - set_fact - позволяет установить переменные, связанные с текущим хостом
    > - copy - копирует файл с локального или удаленного компьютера в место на удаленном компьютере
    > - file - установите атрибуты файлов, символических ссылок или каталогов
    >   - state: directory -будут созданы все промежуточные подкаталоги, если они не существуют
    > - unarchive - распаковывает архив
    > - template - обрабатывает шаблоны языком Jinja2
    > - get_url - загружает файлы с HTTP, HTTPS или FTP на удаленный сервер
    >
    > ## Тэги Playbook
    >
    > Наш playbook содержит три тэга
    >
    > - java - все действия связанные с установкой JDK
    > - elastic - все действия связанные с установкой Elasticsearch
    > - kibana - все действия связанные с установкой Kibana
    >
    > В данном задание мы выполняли все действия, но при необходимости тэги позволяют нам запускать только нужные задачи.  
    > Пример установи JDK:
    >
    > ```shell
    > ansible-playbook site.yml -i inventory/prod.yml -t java
    > ```
    >

10. Готовый playbook выложите в свой репозиторий, в ответ предоставьте ссылку на него.

    - Ссылка на [директорию с playbook](https://github.com/tasmity/devops-netology/blob/main/ansible/playbook-2)
