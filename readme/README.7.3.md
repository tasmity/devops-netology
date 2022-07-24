# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно)

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием терраформа и aws.

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя, а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано здесь.
2. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше.

## Задача 2. Инициализируем проект и создаем воркспейсы

1. Выполните terraform init:
    - если был создан бэкэнд в S3, то терраформ создаст файл стейтов в S3 и запись в таблице dynamodb.
    - иначе будет создан локальный файл со стейтами.
2. Создайте два воркспейса stage и prod.
3. В уже созданный aws_instance добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах
использовались разные instance_type.
4. Добавим count. Для stage должен создаться один экземпляр ec2, а для prod два.
5. Создайте рядом еще один aws_instance, но теперь определите их количество при помощи for_each, а не count.
6. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла create_before_destroy = true в один из ресурсов aws_instance.
7. При желании поэкспериментируйте с другими параметрами и ресурсами.

В виде результата работы пришлите:

- Вывод команды terraform workspace list.
- Вывод команды terraform plan для воркспейса prod.

Ответ:

Все файлы конфигурации лежат в [репозитории](https://github.com/tasmity/devops-netology/tree/main/terraform/terraform-2)

```shell
❯ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of yandex-cloud/yandex...
- Installing yandex-cloud/yandex v0.76.0...
- Installed yandex-cloud/yandex v0.76.0 (self-signed, key ID E40F590B50BB8E40)

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
```

```shell
❯ terraform workspace new stage
Created and switched to workspace "stage"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
```

```shell
❯ terraform workspace new prod
Created and switched to workspace "prod"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
```

```shell
❯ terraform workspace list
  default
* prod
  stage
```

```shell
❯ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.node[0] will be created
  + resource "yandex_compute_instance" "node" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "node01.netology.yc"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDC2D9kbDGZ3RqGiMn4IK//glVmne4mTs8YhHHALgtsQrFXwHZWj1o8DBiVzT2qBwfmfdPTWYbQnrfMwoVfALGz22drNWdHMneydZ/sZZk7l3v9Bk0OXmT5yO3S0paA6UuAU55QLP7l29T4cDVZZJkBxxjsuNBZgf5BnfOkKrcwXa3e1q/ZlmoRXVu2eKm8mZRNCwJIJb81Cwy3nglDczXhZ6vGLvAYdvsbEGRCWJwOjQVQxxOQpTKMs2jRTpAoBOM1R0HsqAKSojvTHGgClsDOkQPmuQ9ewhTj8EnRC7VhL3C7NA0spvLis0/QDkET2hgCoowoC2wmGUeSAHnx7HcO9Tl2/D/FwIPgpM75VdjBsba9cJpRdSz/26JKm9KT1drhbcjh5Pyh8oBNMSrO0dDImHEhU7sLhaw3juEzMBGgCyyXYOrmZJuaEEvbkEBTncGH/2Wb1DxsrbpY8q/sLdmduv6hwbzHUMQFMsQMEXuegqFBNpf088K7rQ4iW2wScRM= tasmity@iTata
            EOT
        }
      + name                      = "node01-prod"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8t5b0g7octm48d9q3i"
              + name        = "root-node01"
              + size        = 10
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 20
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.node[1] will be created
  + resource "yandex_compute_instance" "node" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "node02.netology.yc"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDC2D9kbDGZ3RqGiMn4IK//glVmne4mTs8YhHHALgtsQrFXwHZWj1o8DBiVzT2qBwfmfdPTWYbQnrfMwoVfALGz22drNWdHMneydZ/sZZk7l3v9Bk0OXmT5yO3S0paA6UuAU55QLP7l29T4cDVZZJkBxxjsuNBZgf5BnfOkKrcwXa3e1q/ZlmoRXVu2eKm8mZRNCwJIJb81Cwy3nglDczXhZ6vGLvAYdvsbEGRCWJwOjQVQxxOQpTKMs2jRTpAoBOM1R0HsqAKSojvTHGgClsDOkQPmuQ9ewhTj8EnRC7VhL3C7NA0spvLis0/QDkET2hgCoowoC2wmGUeSAHnx7HcO9Tl2/D/FwIPgpM75VdjBsba9cJpRdSz/26JKm9KT1drhbcjh5Pyh8oBNMSrO0dDImHEhU7sLhaw3juEzMBGgCyyXYOrmZJuaEEvbkEBTncGH/2Wb1DxsrbpY8q/sLdmduv6hwbzHUMQFMsQMEXuegqFBNpf088K7rQ4iW2wScRM= tasmity@iTata
            EOT
        }
      + name                      = "node02-prod"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8t5b0g7octm48d9q3i"
              + name        = "root-node02"
              + size        = 10
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 20
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.node_for_each["prod"] will be created
  + resource "yandex_compute_instance" "node_for_each" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "node02.netology.yc"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDC2D9kbDGZ3RqGiMn4IK//glVmne4mTs8YhHHALgtsQrFXwHZWj1o8DBiVzT2qBwfmfdPTWYbQnrfMwoVfALGz22drNWdHMneydZ/sZZk7l3v9Bk0OXmT5yO3S0paA6UuAU55QLP7l29T4cDVZZJkBxxjsuNBZgf5BnfOkKrcwXa3e1q/ZlmoRXVu2eKm8mZRNCwJIJb81Cwy3nglDczXhZ6vGLvAYdvsbEGRCWJwOjQVQxxOQpTKMs2jRTpAoBOM1R0HsqAKSojvTHGgClsDOkQPmuQ9ewhTj8EnRC7VhL3C7NA0spvLis0/QDkET2hgCoowoC2wmGUeSAHnx7HcO9Tl2/D/FwIPgpM75VdjBsba9cJpRdSz/26JKm9KT1drhbcjh5Pyh8oBNMSrO0dDImHEhU7sLhaw3juEzMBGgCyyXYOrmZJuaEEvbkEBTncGH/2Wb1DxsrbpY8q/sLdmduv6hwbzHUMQFMsQMEXuegqFBNpf088K7rQ4iW2wScRM= tasmity@iTata
            EOT
        }
      + name                      = "node02-prod-for_each"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8t5b0g7octm48d9q3i"
              + name        = "root-node02"
              + size        = 10
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 20
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.node_for_each["stage"] will be created
  + resource "yandex_compute_instance" "node_for_each" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "node01.netology.yc"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDC2D9kbDGZ3RqGiMn4IK//glVmne4mTs8YhHHALgtsQrFXwHZWj1o8DBiVzT2qBwfmfdPTWYbQnrfMwoVfALGz22drNWdHMneydZ/sZZk7l3v9Bk0OXmT5yO3S0paA6UuAU55QLP7l29T4cDVZZJkBxxjsuNBZgf5BnfOkKrcwXa3e1q/ZlmoRXVu2eKm8mZRNCwJIJb81Cwy3nglDczXhZ6vGLvAYdvsbEGRCWJwOjQVQxxOQpTKMs2jRTpAoBOM1R0HsqAKSojvTHGgClsDOkQPmuQ9ewhTj8EnRC7VhL3C7NA0spvLis0/QDkET2hgCoowoC2wmGUeSAHnx7HcO9Tl2/D/FwIPgpM75VdjBsba9cJpRdSz/26JKm9KT1drhbcjh5Pyh8oBNMSrO0dDImHEhU7sLhaw3juEzMBGgCyyXYOrmZJuaEEvbkEBTncGH/2Wb1DxsrbpY8q/sLdmduv6hwbzHUMQFMsQMEXuegqFBNpf088K7rQ4iW2wScRM= tasmity@iTata
            EOT
        }
      + name                      = "node01-prod-for_each"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8t5b0g7octm48d9q3i"
              + name        = "root-node01"
              + size        = 10
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 20
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.default will be created
  + resource "yandex_vpc_network" "default" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.default will be created
  + resource "yandex_vpc_subnet" "default" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.101.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 6 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.

```
