# Домашнее задание к занятию "3.5. Файловые системы"

## 1. Узнайте о разреженных (разряженных) файлах.
Ответ:
>Разрежённый файл (англ. sparse file) — файл, в котором последовательности нулевых байтов[1] заменены на информацию об
> этих последовательностях (список дыр).
>
> Дыра (англ. hole) — последовательность нулевых байт внутри файла, не записанная на диск. Информация о дырах (смещение
> от начала файла в байтах и количество байт) хранится в метаданных ФС.
> 
> Преимущества:
> + экономия дискового пространства. Использование разрежённых файлов считается одним из способов сжатия данных на
> уровне файловой системы;
> + отсутствие временных затрат на запись нулевых байт;
> + увеличение срока службы запоминающих устройств.
> 
> Недостатки:
> + накладные расходы на работу со списком дыр;
> + фрагментация файла при частой записи данных в дыры;
> + невозможность записи данных в дыры при отсутствии свободного места на диске;
> + невозможность использования других индикаторов дыр, кроме нулевых байт.

## 2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
Ответ:
> В Linux каждый файл имеет уникальный идентификатор - индексный дескриптор (inode). Это число, которое однозначно
> идентифицирует файл в файловой системе. Жесткая ссылка и файл, для которой она создавалась имеют одинаковые inode.
> Поэтому жесткая ссылка имеет те же права доступа, владельца и время последней модификации, что и целевой файл.
> Различаются только имена файлов. Фактически жесткая ссылка это еще одно имя для файла.

## 3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:
```shell
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.provider :virtualbox do |vb|
    lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
    lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
    vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
    vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
  end
end
```
Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

Ответ:
```shell
vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk
sdc                    8:32   0  2.5G  0 disk
```

## 4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
Ответ:
```shell
vagrant@vagrant:~$ sudo fdisk /dev/sdb

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x80991919.

# g - создать пустую таблицу разделов GPT
Command (m for help): g
Created a new GPT disklabel (GUID: 495E2836-C2FF-1C47-BFA1-DE187752BFFC).

# n - создать новый раздел
Command (m for help): n
Partition number (1-128, default 1):
First sector (2048-5242846, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242846, default 5242846): +2G

Created a new partition 1 of type 'Linux filesystem' and of size 2 GiB.

Command (m for help): n
Partition number (2-128, default 2):
First sector (4196352-5242846, default 4196352):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242846, default 5242846):

Created a new partition 2 of type 'Linux filesystem' and of size 511 MiB.

# w - записать новую таблицу разделов на диск
Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

## 5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.
Ответ:
```shell
vagrant@vagrant:~$ sudo sfdisk -d /dev/sdb | sudo sfdisk /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new GPT disklabel (GUID: 495E2836-C2FF-1C47-BFA1-DE187752BFFC).
/dev/sdc1: Created a new partition 1 of type 'Linux filesystem' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux filesystem' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: gpt
Disk identifier: 495E2836-C2FF-1C47-BFA1-DE187752BFFC

Device       Start     End Sectors  Size Type
/dev/sdc1     2048 4196351 4194304    2G Linux filesystem
/dev/sdc2  4196352 5242846 1046495  511M Linux filesystem

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

## 6. Соберите mdadm RAID1 на паре разделов 2 Гб.
Ответ:

На этом моменте была невнимательна, накосячила. Можно было пересоздать VM, но исправить показалось интересней. 
Пришлось удалить RAID и еще раз пройтись по предыдущим пунктам:
```shell
vagrant@vagrant:~$ sudo mdadm --create --verbose /dev/md0 -l 1 -n 2 /dev/sd{b,c}
mdadm: partition table exists on /dev/sdb
mdadm: partition table exists on /dev/sdb but will be lost or
       meaningless after creating array
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: partition table exists on /dev/sdc
mdadm: partition table exists on /dev/sdc but will be lost or
       meaningless after creating array
mdadm: size set to 2618368K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

vagrant@vagrant:~$ sudo mdadm -S /dev/md0
mdadm: stopped /dev/md0

vagrant@vagrant:~$ sudo mdadm --zero-superblock /dev/sdb

vagrant@vagrant:~$ sudo mdadm --zero-superblock /dev/sdc

vagrant@vagrant:~$ sudo wipefs --all --force /dev/sd{b,c}
/dev/sdb: 8 bytes were erased at offset 0x00000200 (gpt): 45 46 49 20 50 41 52 54
/dev/sdb: 8 bytes were erased at offset 0x9ffffe00 (gpt): 45 46 49 20 50 41 52 54
/dev/sdb: 2 bytes were erased at offset 0x000001fe (PMBR): 55 aa
/dev/sdc: 8 bytes were erased at offset 0x00000200 (gpt): 45 46 49 20 50 41 52 54
/dev/sdc: 8 bytes were erased at offset 0x9ffffe00 (gpt): 45 46 49 20 50 41 52 54
/dev/sdc: 2 bytes were erased at offset 0x000001fe (PMBR): 55 aa

vagrant@vagrant:~$ sudo fdisk /dev/sdb

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x0f8cb2bc.

Command (m for help): g
Created a new GPT disklabel (GUID: 4E609AF4-9A22-EE47-BACA-91E9E586C81D).

Command (m for help): n
Partition number (1-128, default 1):
First sector (2048-5242846, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242846, default 5242846): +2G

Created a new partition 1 of type 'Linux filesystem' and of size 2 GiB.

Command (m for help): n
Partition number (2-128, default 2):
First sector (4196352-5242846, default 4196352):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242846, default 5242846):

Created a new partition 2 of type 'Linux filesystem' and of size 511 MiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.



vagrant@vagrant:~$ sudo sfdisk -d /dev/sdb | sudo sfdisk /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new GPT disklabel (GUID: 4E609AF4-9A22-EE47-BACA-91E9E586C81D).
/dev/sdc1: Created a new partition 1 of type 'Linux filesystem' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux filesystem' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: gpt
Disk identifier: 4E609AF4-9A22-EE47-BACA-91E9E586C81D

Device       Start     End Sectors  Size Type
/dev/sdc1     2048 4196351 4194304    2G Linux filesystem
/dev/sdc2  4196352 5242846 1046495  511M Linux filesystem

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

Переделала:

```shell
vagrant@vagrant:~$ sudo mdadm --create --verbose /dev/md0 -l 1 -n 2 /dev/sd{b1,c1}
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
```
>+ /dev/md0 — устройство RAID, которое появится после сборки; 
>+ -l 1 — уровень RAID; 
>+ -n 2 — количество дисков, из которых собирается массив; 
>+ /dev/sd{b1,c1} — сборка выполняется из дисков sdb1 и sdc1.

## 7. Соберите mdadm RAID0 на второй паре маленьких разделов.
Ответ:
```shell
vagrant@vagrant:~$ sudo mdadm --create --verbose /dev/md1 -l 0 -n 2 /dev/sd{b2,c2}
mdadm: chunk size defaults to 512K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
```

## 8. Создайте 2 независимых PV на получившихся md-устройствах.
Ответ:
```shell
vagrant@vagrant:~$ sudo pvcreate /dev/md0 /dev/md1
  Physical volume "/dev/md0" successfully created.
  Physical volume "/dev/md1" successfully created.
```

## 9. Создайте общую volume-group на этих двух PV.
Ответ:
```shell
vagrant@vagrant:~$ sudo vgcreate netology_vg /dev/md0 /dev/md1
  Volume group "netology_vg" successfully created
```

## 10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
Ответ:
```shell
vagrant@vagrant:~$ sudo lvcreate -L 100M netology_vg /dev/md1
  Logical volume "lvol0" created.
```

## 11. Создайте mkfs.ext4 ФС на получившемся LV.
Ответ:
```shell
vagrant@vagrant:~$ sudo mkfs.ext4 /dev/netology_vg/lvol0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```

## 12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.
Ответ:
```shell
vagrant@vagrant:~$ mkdir /tmp/new
vagrant@vagrant:~$ sudo mount  /dev/netology_vg/lvol0 /tmp/new
```

## 13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.
Ответ:
```shell
vagrant@vagrant:~$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2021-11-27 20:23:58--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22607126 (22M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz                                    100%[==================================>]  21.56M  4.87MB/s    in 12s

2021-11-27 20:24:11 (1.73 MB/s) - ‘/tmp/new/test.gz’ saved [22607126/22607126]
```

## 14. Прикрепите вывод lsblk.
Ответ:
```shell
vagrant@vagrant:~$ lsblk
NAME                    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                       8:0    0   64G  0 disk
├─sda1                    8:1    0  512M  0 part  /boot/efi
├─sda2                    8:2    0    1K  0 part
└─sda5                    8:5    0 63.5G  0 part
  ├─vgvagrant-root      253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1    253:1    0  980M  0 lvm   [SWAP]
sdb                       8:16   0  2.5G  0 disk
├─sdb1                    8:17   0    2G  0 part
│ └─md0                   9:0    0    2G  0 raid1
└─sdb2                    8:18   0  511M  0 part
  └─md1                   9:1    0 1017M  0 raid0
    └─netology_vg-lvol0 253:2    0  100M  0 lvm   /tmp/new
sdc                       8:32   0  2.5G  0 disk
├─sdc1                    8:33   0    2G  0 part
│ └─md0                   9:0    0    2G  0 raid1
└─sdc2                    8:34   0  511M  0 part
  └─md1                   9:1    0 1017M  0 raid0
    └─netology_vg-lvol0 253:2    0  100M  0 lvm   /tmp/new
```

## 15. Протестируйте целостность файла:
```shell
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
```
Ответ:
```shell
vagrant@vagrant:~$ gzip -t /tmp/new/test.gz
vagrant@vagrant:~$ echo $?
0
```

## 16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
Ответ:
```shell
vagrant@vagrant:~$ sudo pvmove /dev/md1 /dev/md0
  /dev/md1: Moved: 24.00%
  /dev/md1: Moved: 100.00%
  
vagrant@vagrant:~$ lsblk
NAME                    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                       8:0    0   64G  0 disk
├─sda1                    8:1    0  512M  0 part  /boot/efi
├─sda2                    8:2    0    1K  0 part
└─sda5                    8:5    0 63.5G  0 part
  ├─vgvagrant-root      253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1    253:1    0  980M  0 lvm   [SWAP]
sdb                       8:16   0  2.5G  0 disk
├─sdb1                    8:17   0    2G  0 part
│ └─md0                   9:0    0    2G  0 raid1
│   └─netology_vg-lvol0 253:2    0  100M  0 lvm   /tmp/new
└─sdb2                    8:18   0  511M  0 part
  └─md1                   9:1    0 1017M  0 raid0
sdc                       8:32   0  2.5G  0 disk
├─sdc1                    8:33   0    2G  0 part
│ └─md0                   9:0    0    2G  0 raid1
│   └─netology_vg-lvol0 253:2    0  100M  0 lvm   /tmp/new
└─sdc2                    8:34   0  511M  0 part
  └─md1                   9:1    0 1017M  0 raid0
```

## 17. Сделайте --fail на устройство в вашем RAID1 md.
Ответ:
```shell
vagrant@vagrant:~$ sudo mdadm /dev/md0 -f /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0
```

## 18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.
Ответ:
```shell
vagrant@vagrant:~$ dmesg
................................................................
[ 3351.571296] md/raid1:md0: Disk failure on sdb1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
................................................................

```

## 19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:
```shell
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
```
Ответ:
```shell
vagrant@vagrant:~$ gzip -t /tmp/new/test.gz
vagrant@vagrant:~$ echo $?
0
```

## 20. Погасите тестовый хост, vagrant destroy.
Ответ:
```shell
❯ vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
```