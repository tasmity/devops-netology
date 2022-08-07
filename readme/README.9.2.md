# Домашнее задание к занятию "09.02 CI\CD"

## Знакомоство с SonarQube

### Подготовка к выполнению

1. Выполняем docker pull sonarqube:8.7-community

   ```shell
   ╭─···········································································╮
   ╰─ docker pull sonarqube:8.7-community
   8.7-community: Pulling from library/sonarqube
   22599d3e9e25: Pull complete
   00bb4d95f2aa: Pull complete
   3ef8cf8a60c8: Pull complete
   928990dd1bda: Pull complete
   07cca701c22e: Pull complete
   Digest: sha256:70496f44067bea15514f0a275ee898a7e4a3fedaaa6766e7874d24a39be336dc
   Status: Downloaded newer image for sonarqube:8.7-community
   docker.io/library/sonarqube:8.7-community
   ```

2. Выполняем docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:8.7-community

   ```shell
   ╭─···········································································╮
   ╰─ docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:8.7-community
   197ef0cd8ab3944a0cc4ef9ddff14668badb317e4c4b45850cab16fddbfdf2fd
   ```

3. Ждём запуск, смотрим логи через docker logs -f sonarqube

   ```shell
   ╭─···········································································╮
   ╰─ docker logs -f sonarqube
   ................................................................
   2022.08.07 11:35:30 INFO  ce[][o.s.c.t.CeWorkerImpl] worker AYJ4Fq34MxpFt7Tks_V6 found no pending task
   (including indexation task). Disabling indexation task lookup for this worker until next SonarQube restart.
   ```

4. Проверяем готовность сервиса через браузер

   ![login](https://github.com/tasmity/devops-netology/blob/main/image/9.2/1.png)

5. Заходим под admin\admin, меняем пароль на свой

   ![change login](https://github.com/tasmity/devops-netology/blob/main/image/9.2/2.png)

В целом, в этой статье описаны все варианты установки, включая и [docker](https://docs.sonarqube.org/latest/setup/install-server/),
но так как нам он нужен разово, то достаточно того набора действий, который я указал выше.

### Основная часть

1. Создаём новый проект, название произвольное

   ![project](https://github.com/tasmity/devops-netology/blob/main/image/9.2/3.png)

2. Скачиваем пакет sonar-scanner, который нам предлагает скачать сам sonarqube

   ```shell
   /home/sonarqube # wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.7.0.2747-linux.zip
   Connecting to binaries.sonarsource.com (13.33.243.128:443)
   saving to 'sonar-scanner-cli-4.7.0.2747-linux.zip'
   sonar-scanner-cli-4. 100% |**************************************************************************************************************************| 41.1M  0:00:00 ETA
   'sonar-scanner-cli-4.7.0.2747-linux.zip' saved
   
   /home/sonarqube # apk add unzip
   fetch http://dl-cdn.alpinelinux.org/alpine/v3.12/main/x86_64/APKINDEX.tar.gz
   fetch http://dl-cdn.alpinelinux.org/alpine/v3.12/community/x86_64/APKINDEX.tar.gz
   (1/1) Installing unzip (6.0-r9)
   Executing busybox-1.31.1-r19.trigger
   OK: 41 MiB in 34 packages
   
   /home/sonarqube # unzip sonar-scanner-cli-4.7.0.2747-linux.zip
   Archive:  sonar-scanner-cli-4.7.0.2747-linux.zip
   ................................................................
   ```

3. Делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)

   ```shell
   /home/sonarqube # export PATH=$PATH:/home/sonarqube/sonar-scanner-4.7.0.2747-linux/bin/
   ```

4. Проверяем sonar-scanner --version

   ```shell
   /home/sonarqube # sonar-scanner --version
   INFO: Scanner configuration file: /home/sonarqube/sonar-scanner-4.7.0.2747-linux/conf/sonar-scanner.properties
   INFO: Project root configuration file: NONE
   INFO: SonarScanner 4.7.0.2747
   INFO: Java 11.0.14.1 Eclipse Adoptium (64-bit)
   INFO: Linux 5.10.104-linuxkit amd64
   ```

5. Запускаем анализатор против кода из директории [example](https://github.com/netology-code/mnt-homeworks/blob/master/09-ci-02-cicd/example)
с дополнительным ключом -Dsonar.coverage.exclusions=fail.py

   ```shell
   ╭─···········································································╮
   ╰─ brew install sonar-scanner
   Running `brew update --auto-update`...
   ................................................................
   Pruned 3 symbolic links and 12 directories from /usr/local
   ```

   ```shell
   ╭─···········································································╮
   ╰─ sonar-scanner \
   -Dsonar.projectKey=netology \
   -Dsonar.sources=. \
   -Dsonar.host.url=http://localhost:9000 \
   -Dsonar.login=b7cb3d5f7b8b02b9389c4c4a05bb711b7545bebf \
   -Dsonar.coverage.exclusions=fail.py
   ........................................................
   INFO: ------------------------------------------------------------------------
   INFO: EXECUTION SUCCESS
   INFO: ------------------------------------------------------------------------
   INFO: Total time: 12.654s
   INFO: Final Memory: 7M/88M
   INFO: ------------------------------------------------------------------------
   ```

6. Смотрим результат в интерфейсе

    ![scan](https://github.com/tasmity/devops-netology/blob/main/image/9.2/4.png)

    ![bug](https://github.com/tasmity/devops-netology/blob/main/image/9.2/5.png)

7. Исправляем ошибки, которые он выявил(включая warnings)

   ```python
   def increment(ind):
    return ind + 1


   def get_square(numb):
       return numb * numb
   
   
   def print_numb(numb):
       print("Number is {}".format(numb))
   
   
   index = 0
   while index < 10:
       index = increment(index)
       print_numb(get_square(index))

   ```
8. Запускаем анализатор повторно - проверяем, что QG пройдены успешно

   ```shell
   ╭─···········································································╮
   ╰─ sonar-scanner \
   -Dsonar.projectKey=netology \
   -Dsonar.sources=. \
   -Dsonar.host.url=http://localhost:9000 \
   -Dsonar.login=b7cb3d5f7b8b02b9389c4c4a05bb711b7545bebf \
   -Dsonar.coverage.exclusions=fail.py
   ........................................................
   INFO: ------------------------------------------------------------------------
   INFO: EXECUTION SUCCESS
   INFO: ------------------------------------------------------------------------
   INFO: EXECUTION SUCCESS
   INFO: ------------------------------------------------------------------------
   INFO: Total time: 9.212s
   INFO: Final Memory: 7M/88M
   INFO: ------------------------------------------------------------------------
   ```

9. Делаем скриншот успешного прохождения анализа, прикладываем к решению ДЗ

   ![good](https://github.com/tasmity/devops-netology/blob/main/image/9.2/6.png)

## Знакомство с Nexus

### Подготовка к выполнению

1. Выполняем docker pull sonatype/nexus3

   ```shell
   ╭─···········································································╮
   ╰─ docker pull sonatype/nexus3
   Using default tag: latest
   latest: Pulling from sonatype/nexus3
   0c673eb68f88: Pull complete
   028bdc977650: Pull complete
   887448ad6f44: Pull complete
   70daa52d5897: Pull complete
   Digest: sha256:d0f242d00a2f93f1bdf4e30cb2c0d1be03217f792db5af17727871bae04783da
   Status: Downloaded newer image for sonatype/nexus3:latest
   docker.io/sonatype/nexus3:lates
   ```

2. Выполняем docker run -d -p 8081:8081 --name nexus sonatype/nexus3

   ```shell
   ╭─···········································································╮
   ╰─ docker run -d -p 8081:8081 --name nexus sonatype/nexus3
   6bca69d4e955b022766d29f9a7f129cbb338946524f0c093c6a27e18061c1f96
   ```

3. Ждём запуск, смотрим логи через docker logs -f nexus

   ```shell
   ╭─···········································································╮
   ╰─ docker logs -f nexus
   ................................................................
   -------------------------------------------------

   Started Sonatype Nexus OSS 3.41.0-01
   
   -------------------------------------------------
   ```

4. Проверяем готовность сервиса через бразуер

   ![nexus](https://github.com/tasmity/devops-netology/blob/main/image/9.2/7.png)

5. Узнаём пароль от admin через docker exec -it nexus /bin/bash

   ```shell
   ╭─···········································································╮
   ╰─ docker exec -it nexus /bin/bash
   ```

   ```shell
   bash-4.4$ cat nexus-data/admin.password
   6e7dc9e7-8b55-4273-9ce2-5390d32d5ed4bash-4.4$
   ```

6. Подключаемся под админом, меняем пароль, сохраняем анонимный доступ

      ![shange_pass](https://github.com/tasmity/devops-netology/blob/main/image/9.2/8.png)

      ![anonim](https://github.com/tasmity/devops-netology/blob/main/image/9.2/9.png)

### Основная часть

1. В репозиторий maven-public загружаем артефакт с GAV параметрами:
   1. groupId: netology 
   2. artifactId: java 
   3. version: 8_282 
   4. classifier: distrib 
   5. type: tar.gz
2. В него же загружаем такой же артефакт, но с version: 8_102
3. Проверяем, что все файлы загрузились успешно

   ![java](https://github.com/tasmity/devops-netology/blob/main/image/9.2/10.png)

4. В ответе присылаем файл maven-metadata.xml для этого артефекта

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <metadata modelVersion="1.1.0">
     <groupId>netology</groupId>
     <artifactId>java</artifactId>
     <versioning>
       <latest>8_282</latest>
       <release>8_282</release>
       <versions>
         <version>8_102</version>
         <version>8_282</version>
       </versions>
       <lastUpdated>20220807142606</lastUpdated>
     </versioning>
   </metadata>
   ```

## Знакомство с Maven

### Подготовка к выполнению

1. Скачиваем дистрибутив с [maven](https://maven.apache.org/download.cgi)

   ```text
   Так как maven был уже установлен, пропустила данный пункт подготовки. Устанавливался, через `brew install maven`
   ```

2. Разархивируем, делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой
другой удобный вам способ)

   ```text
   Тоже пропущено, но могли повторить, через export PATH=, как мы это делали с sonar-scanner
   ```

3. Проверяем mvn --version

   ```shell
   ╭─···········································································╮
   ╰─ mvn --version                                                                                                                                                       ─╯
   Apache Maven 3.8.6 (84538c9988a25aec085021c365c560670ad80f63)
   Maven home: /usr/local/Cellar/maven/3.8.6/libexec
   Java version: 18.0.2, vendor: Homebrew, runtime: /usr/local/Cellar/openjdk/18.0.2/libexec/openjdk.jdk/Contents/Home
   Default locale: ru_RU, platform encoding: UTF-8
   OS name: "mac os x", version: "12.4", arch: "x86_64", family: "mac"
   ```
4. Забираем директорию [mvn](https://github.com/netology-code/mnt-homeworks/blob/master/09-ci-02-cicd/mvn) с pom

### Основная часть
1. Меняем в pom.xml блок с зависимостями под наш артефакт из первого пункта задания для Nexus (java с версией 8_282)
2. Запускаем команду mvn package в директории с pom.xml, ожидаем успешного окончания

   ```shell
   ╭─···········································································╮
   ╰─ mvn package                                                                                                                                                         ─╯
   [INFO] Scanning for projects...
   [INFO]
   [INFO] --------------------< com.netology.app:simple-app >---------------------
   [INFO] Building simple-app 1.0-SNAPSHOT
   [INFO] --------------------------------[ jar ]---------------------------------
   ....................................................
   [INFO] Building jar: /Users/tasmity/app/mvn/target/simple-app-1.0-SNAPSHOT.jar
   [INFO] ------------------------------------------------------------------------
   [INFO] BUILD SUCCESS
   [INFO] ------------------------------------------------------------------------
   [INFO] Total time:  6.740 s
   [INFO] Finished at: 2022-08-07T18:01:53+03:00
   [INFO] ------------------------------------------------------------------------
   ```

3. Проверяем директорию ~/.m2/repository/, находим наш артефакт

   ```shell
   ╭─···········································································╮
   ╰─ ls -la ~/.m2/repository/netology/java/8_282                                                                                                                         ─╯
     rwxr-xr-x  6  tasmity  staff   192 B    Sun Aug  7 18:01:49 2022    ./
     rwxr-xr-x  3  tasmity  staff    96 B    Sun Aug  7 18:01:48 2022    ../
     rw-r--r--  1  tasmity  staff   175 B    Sun Aug  7 18:01:49 2022    _remote.repositories
     rw-r--r--  1  tasmity  staff   371 B    Sun Aug  7 18:01:49 2022    java-8_282-distrib.tar.gz
     rw-r--r--  1  tasmity  staff    40 B    Sun Aug  7 18:01:49 2022    java-8_282-distrib.tar.gz.sha1
     rw-r--r--  1  tasmity  staff   382 B    Sun Aug  7 18:01:49 2022    java-8_282.pom.lastUpdated
   ```

4. В ответе присылаем исправленный файл pom.xml

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
     <modelVersion>4.0.0</modelVersion>
   
     <groupId>com.netology.app</groupId>
     <artifactId>simple-app</artifactId>
     <version>1.0-SNAPSHOT</version>
      <repositories>
       <repository>
         <id>my-repo</id>
         <name>maven-public</name>
         <url>http://localhost:8081/repository/maven-public/</url>
       </repository>
     </repositories>
     <dependencies>
       <dependency>
         <groupId>netology</groupId>
         <artifactId>java</artifactId>
         <version>8_282</version>
         <classifier>distrib</classifier>
         <type>tar.gz</type>
       </dependency>
     </dependencies>
   </project>

   ```
