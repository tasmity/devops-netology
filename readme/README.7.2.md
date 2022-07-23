# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."

Зачастую разбираться в новых инструментах гораздо интересней понимая то, как они работают изнутри. Поэтому в рамках
первого необязательного задания предлагается завести свою учетную запись в AWS (Amazon Web Services) или Yandex.Cloud.
Идеально будет познакомится с обоими облаками, потому что они отличаются.

## Задача 1 (вариант с AWS). Регистрация в aws и знакомство с основами (необязательно, но крайне желательно)

Остальные задания можно будет выполнять и без этого аккаунта, но с ним можно будет увидеть полный цикл процессов.

AWS предоставляет достаточно много бесплатных ресурсов в первый год после регистрации, подробно описано [здесь](https://aws.amazon.com/free/).

1. Создайте аккаунт aws.
2. Установите c aws-cli <https://aws.amazon.com/cli/>.
3. Выполните первичную настройку aws-sli <https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html>.
4. Создайте IAM политику для терраформа c правами  
   - AmazonEC2FullAccess
   - AmazonS3FullAccess
   - AmazonDynamoDBFullAccess
   - AmazonRDSFullAccess
   - CloudWatchFullAccess
   - IAMFullAccess
5. Добавьте переменные окружения

    ```shell
   export AWS_ACCESS_KEY_ID=(your access key id)
   export AWS_SECRET_ACCESS_KEY=(your secret access key)
   ```

6. Создайте, остановите и удалите ec2 инстанс (любой с пометкой free tier) через веб интерфейс.  

В виде результата задания приложите вывод команды aws configure list.

## Задача 1 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно)

1. Подробная инструкция на русском языке содержится [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
2. Обратите внимание на период бесплатного использования после регистрации аккаунта.
3. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для
подготовки базового терраформ конфига.
4. Воспользуйтесь [инструкцией](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs) на сайте
терраформа, что бы не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

## Задача 2. Создание aws ec2 или yandex_compute_instance через терраформ

1. В каталоге terraform вашего основного репозитория, который был создан в начале курсе, создайте файл main.tf и
versions.tf.
2. Зарегистрируйте провайдер
   1. для [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs). В файл main.tf добавьте блок
provider, а в versions.tf блок terraform с вложенным блоком required_providers. Укажите любой выбранный вами регион внутри блока provider.
   2. либо для [yandex.cloud](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs).
Подробную инструкцию можно найти [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
3. Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунту. Поэтому в предыдущем задании мы
указывали их в виде переменных окружения.
4. В файле main.tf воспользуйтесь блоком data "aws_ami для поиска ami образа последнего Ubuntu.
5. В файле main.tf создайте рессурс
   1. либо [ec2 instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance).
Постарайтесь указать как можно больше параметров для его определения. Минимальный набор параметров указан в первом блоке Example Usage, но желательно, указать большее количество параметров.
   2. либо [yandex_compute_image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_image).
6. Также в случае использования aws:
   1. Добавьте data-блоки aws_caller_identity и aws_region.
   2. В файл outputs.tf поместить блоки output с данными об используемых в данный момент:
      - AWS account ID,
      - AWS user ID,
      - AWS регион, который используется в данный момент,
      - Приватный IP ec2 инстансы,
      - Идентификатор подсети в которой создан инстанс.
7. Если вы выполнили первый пункт, то добейтесь того, что бы команда terraform plan выполнялась без ошибок.

В качестве результата задания предоставьте:

Ответ:

```shell
❯ packer validate centos-7-base.json
The configuration is valid.
```

```shell
❯ packer build centos-7-base.json
................................................................
==> Wait completed after 4 minutes 28 seconds

==> Builds finished. The artifacts of successful builds are:
--> yandex: A disk image was created: centos-7-base (id: fd8t5b0g7octm48d9q3i) with family name centos
```

```shell
❯ terraform plan
................................................................
Plan: 3 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

```shell
❯ terraform apply -auto-approve
................................................................
Plan: 3 to add, 0 to change, 0 to destroy.
yandex_vpc_network.default: Creating...
yandex_vpc_network.default: Creation complete after 3s [id=enp186ij8shij1qrob0a]
yandex_vpc_subnet.default: Creating...
yandex_vpc_subnet.default: Creation complete after 1s [id=e9bl4k7sdv37for9h2ln]
yandex_compute_instance.node01: Creating...
yandex_compute_instance.node01: Still creating... [10s elapsed]
yandex_compute_instance.node01: Still creating... [20s elapsed]
yandex_compute_instance.node01: Still creating... [30s elapsed]
yandex_compute_instance.node01: Creation complete after 32s [id=fhmtlk8nl683nmapfsta]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```

![Дашборд каталога](https://github.com/tasmity/devops-netology/blob/main/image/terraform/image1.png)
![Виртуальные машины](https://github.com/tasmity/devops-netology/blob/main/image/terraform/image2.png)
![Обзор](https://github.com/tasmity/devops-netology/blob/main/image/terraform/image3.png)

1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
   > Образ создавала с помощью Packer. Данный инструмент мы проходили в работе
   > ["5.4. Оркестрация группы контейнеров Docker на поверхности Docker Compos"](https://github.com/tasmity/devops-netology/blob/main/readme/README.5.4.md)
2. Ссылку на репозиторий с исходной конфигурацией терраформа.
   > Все файлы конфигурации лежат в [репозитории](https://github.com/tasmity/devops-netology/tree/main/terraform)
