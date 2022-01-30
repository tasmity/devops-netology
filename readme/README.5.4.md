# Домашнее задание к занятию "5.4. Оркестрация группы контейнеров Docker на поверхности Docker Compose"

## 1. Создайте собственный образ здоровья системы с помощью Packer.
Для получения зачета, вам необходимо:
+ Скриншот страницы, как на слайде из презентации (слайд 37).
![](https://github.com/tasmity/devops-netology/blob/main/image/docker/yc_03.png)

Ответ:
```shell
╭─······················································································································································· ✔  at 18:18:36  ─╮
╰─ yc init
Welcome! This command will take you through the configuration process.
Pick desired action:
 [1] Re-initialize this profile 'sa-profile' with new settings
 [2] Create a new profile
 [3] Switch to and re-initialize existing profile: 'default'
 [4] Switch to and re-initialize existing profile: 'tasmity'
Please enter your numeric choice: 4
Please go to https://oauth.yandex.ru/authorize?response_type=token&client_id=1a6990aa636648e9b2ef855fa7bec2fb in order to obtain OAuth token.

Please enter OAuth token: [AQAAAAAVz*********************uIxGqvrSU] AQAAAAAVz_zSAATuwaceLhp9RED2r3uIxGqvrSU
You have one cloud available: 'cloud-tasmity' (id = b1g970bjsn1kjlephvs2). It is going to be used by default.
Please choose folder to use:
 [1] default (id = b1g8jtj218k49ce2kq6m)
 [2] netalogia (id = b1gfqukl5b19tttbhh8h)
 [3] netology (id = b1gnf44jp1gq8a5meplc)
 [4] Create a new folder
Please enter your numeric choice: 3
Your current folder has been set to 'netology' (id = b1gnf44jp1gq8a5meplc).
Do you want to configure a default Compute zone? [Y/n] y
Which zone do you want to use as a profile default?
 [1] ru-central1-a
 [2] ru-central1-b
 [3] ru-central1-c
 [4] Don't set default zone
Please enter your numeric choice: 1
Your profile default Compute zone has been set to 'ru-central1-a'.

╭─······················································································································································· ✔  at 18:18:36  ─╮
╰─ yc vpc network create \                                                                                                                                                               ─╯
--name net \
--labels my-label=netology \
--description "my first network via yc"
id: enpp7b18e60ldubma763
folder_id: b1g8jtj218k49ce2kq6m
created_at: "2022-01-30T15:21:28Z"
name: net
description: my first network via yc
labels:
  my-label: netology


╭─······················································································································································· ✔  at 18:21:28  ─╮
╰─ yc vpc subnet create \                                                                                                                                                                ─╯
--name my-subnet-a \
--zone ru-central1-a \
--range 10.1.2.0/24 \
--network-name net \
--description "my first subnet via yc"
id: e9be79ror73id64v6pn2
folder_id: b1g8jtj218k49ce2kq6m
created_at: "2022-01-30T15:24:01Z"
name: my-subnet-a
description: my first subnet via yc
network_id: enpp7b18e60ldubma763
zone_id: ru-central1-a
v4_cidr_blocks:
- 10.1.2.0/24


╭─······················································································································································· ✔  at 18:21:28  ─╮
╰─ packer validate centos7-base.json
The configuration is valid.


╭─······················································································································································· ✔  at 18:21:28  ─╮
╰─  packer build centos7-base.json
........................
    yandex: Complete!
==> yandex: Stopping instance...
==> yandex: Deleting instance...
    yandex: Instance has been deleted!
==> yandex: Creating image: centos-7-base
==> yandex: Waiting for image to complete...
==> yandex: Success image create...
==> yandex: Destroying boot disk...
    yandex: Disk has been deleted!
Build 'yandex' finished after 2 minutes 5 seconds.

==> Wait completed after 2 minutes 5 seconds

==> Builds finished. The artifacts of successful builds are:
--> yandex: A disk image was created: centos-7-base (id: fd8ee3dljn6ukoe32e8p) with family name centos


╭─······················································································································································· ✔  at 18:21:28  ─╮
╰─ yc compute image list
+----------------------+---------------+--------+----------------------+--------+
|          ID          |     NAME      | FAMILY |     PRODUCT IDS      | STATUS |
+----------------------+---------------+--------+----------------------+--------+
| fd8ee3dljn6ukoe32e8p | centos-7-base | centos | f2e6u62hbpkah20ftmhi | READY  |
+----------------------+---------------+--------+----------------------+--------+


╭─······················································································································································· ✔  at 18:21:28  ─╮
╰─ yc vpc subnet delete --name my-subnet-a && yc vpc network delete --name net
done (6s)
```

## 2. Создать вашу первую виртуальную машину в Яндекс.Облаке.
Для получения зачета, вам необходимо:
+ Скриншот страницы свойств созданной ВМ, как на распространении ниже:
![](https://github.com/tasmity/devops-netology/blob/main/image/docker/yc_01.png)

 Ответ:
```shell
╭─······················································································································································· ✔  at 18:21:28  ─╮
╰─ yc iam service-account --folder-id b1gnf44jp1gq8a5meplc list
+----------------------+------------+
|          ID          |    NAME    |
+----------------------+------------+
| aje6bptl42c431mj5n29 | tasmity-sa |
+----------------------+------------+

╭─······················································································································································· ✔  at 18:21:28  ─╮
╰─ yc iam key create --service-account-name tasmity-sa --output key.json
id: ajeg44qat8b0k1pgm3ha
service_account_id: aje6bptl42c431mj5n29
created_at: "2022-01-30T19:07:42.111476809Z"
key_algorithm: RSA_2048

╭─······················································································································································· ✔  at 18:21:28  ─╮
╰─  terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of yandex-cloud/yandex...
- Installing yandex-cloud/yandex v0.70.0...
- Installed yandex-cloud/yandex v0.70.0 (self-signed, key ID E40F590B50BB8E40)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.


╭─······················································································································································· ✔  at 18:21:28  ─╮
╰─  terraform plan
................................................................
Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_node01_yandex_cloud = (known after apply)
  + internal_ip_address_node01_yandex_cloud = (known after apply)


╭─······················································································································································· ✔  at 18:21:28  ─╮
╰─  terraform apply -auto-approve
.................
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_node01_yandex_cloud = "51.250.2.183"
internal_ip_address_node01_yandex_cloud = "192.168.101.13"
```
![](https://github.com/tasmity/devops-netology/blob/main/image/docker/image3.png)

## 3. Создайте свой первый готовый к боевой эксплуатации компонент мониторинга, состоящий из стека микросервисов.
Для получения зачета, вам необходимо:
+ Скриншот работающего веб-интерфейса Grafana с текущими метриками, как показано ниже
![](https://github.com/tasmity/devops-netology/blob/main/image/docker/yc_02.png)

Ответ:
```shell
╭─······················································································································································· ✔  at 18:21:28  ─╮
╰─ ansible-playbook provision.yml

PLAY [nodes] *******************************************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************************
The authenticity of host '51.250.2.183 (51.250.2.183)' can't be established.
ED25519 key fingerprint is SHA256:5j/5Q/85u7LB4icJ4slJDvGS/pt/ABHdDSMlhmF+j4E.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [node01.netology.cloud]

TASK [Create directory for ssh-keys] *******************************************************************************************************************************************************
ok: [node01.netology.cloud]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************************************************************************************************************************
changed: [node01.netology.cloud]

TASK [Checking DNS] ************************************************************************************************************************************************************************
changed: [node01.netology.cloud]

TASK [Installing tools] ********************************************************************************************************************************************************************
changed: [node01.netology.cloud] => (item=['git', 'curl'])

TASK [Add docker repository] ***************************************************************************************************************************************************************
changed: [node01.netology.cloud]

TASK [Installing docker package] ***********************************************************************************************************************************************************
changed: [node01.netology.cloud] => (item=['docker-ce', 'docker-ce-cli', 'containerd.io'])

TASK [Enable docker daemon] ****************************************************************************************************************************************************************
changed: [node01.netology.cloud]

TASK [Install docker-compose] **************************************************************************************************************************************************************
changed: [node01.netology.cloud]

TASK [Synchronization] *********************************************************************************************************************************************************************
changed: [node01.netology.cloud]

TASK [Pull all images in compose] **********************************************************************************************************************************************************
changed: [node01.netology.cloud]

TASK [Up all services in compose] **********************************************************************************************************************************************************
changed: [node01.netology.cloud]

PLAY RECAP *********************************************************************************************************************************************************************************
node01.netology.cloud      : ok=12   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

![](https://github.com/tasmity/devops-netology/blob/main/image/docker/image4.png)
