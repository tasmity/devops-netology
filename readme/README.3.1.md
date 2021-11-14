# Домашнее задание к занятию "3.1. Работа в терминале, лекция 1

## 1. Установите средство виртуализации Oracle VirtualBox.
Установленно, но так как для работы vagrant настороен на работу с 
VMware Fusion, буду пытаться работать на VMware.

## 2. Установите средство автоматизации Hashicorp Vagrant.
```sh
brew install vagrant
```

## 3. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал.
Установлен и настроен iTerm2.
Shell - zsh.
Цветовая схема ZSH_THEME="powerlevel10k/powerlevel10k"

## 4. С помощью базового файла конфигурации запустите Ubuntu 20.04 посредством Vagrant
1. Инициализация директории
```sh
mkdir .vagrant
cd .vagrant
vagrant init
```
Вывод:
```ssh
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
```
2. Правка файла
```sh
vi Vagrantfile
```
```sh
 Vagrant.configure("2") do |config|
 	config.vm.box = "bento/ubuntu-20.04"
 end
 ```
 3. Поднятие виртуалки
```sh
vagrant up
```
Вывод:
```sh
Bringing machine 'default' up with 'vmware_desktop' provider...
==> default: Box 'bento/ubuntu-20.04' could not be found. Attempting to find and install...
    default: Box Provider: vmware_desktop, vmware_fusion, vmware_workstation
    default: Box Version: >= 0
==> default: Loading metadata for box 'bento/ubuntu-20.04'
    default: URL: https://vagrantcloud.com/bento/ubuntu-20.04
==> default: Adding box 'bento/ubuntu-20.04' (v202110.25.0) for provider: vmware_desktop
    default: Downloading: https://vagrantcloud.com/bento/boxes/ubuntu-20.04/versions/202110.25.0/providers/vmware_desktop.box
==> default: Successfully added box 'bento/ubuntu-20.04' (v202110.25.0) for 'vmware_desktop'!
==> default: Cloning VMware VM: 'bento/ubuntu-20.04'. This can take some time...
==> default: Checking if box 'bento/ubuntu-20.04' version '202110.25.0' is up to date...
==> default: Verifying vmnet devices are healthy...
==> default: Preparing network adapters...
==> default: Starting the VMware VM...
==> default: Waiting for the VM to receive an address...
==> default: Forwarding ports...
    default: -- 22 => 2222
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Configuring network adapters within the VM...
==> default: Waiting for HGFS to become available...
==> default: Enabling and configuring shared folders...
    default: -- /Users/tasmity/.vagrant: /vagrant
```

## 5. Какие ресурсы выделены по-умолчанию?
По-умолчаиню следующая конфигурации VM:
2 Processor, 1024 MB Memory, 292,1 MB Hard Disk, IP: 172.16.113.15

## 6. Как добавить оперативной памяти или ресурсов процессора виртуальной машине?
Для изменения оперативной памяти или процессора, отредактировать
Vagrantfile, внеся следующую конфигурациию
1. Для VirtualBox изменить параметы v.memory или v.cpus соответственно
```sh
config.vm.provider "virtualbox" do |v|
  v.memory = 1024
  v.cpus = 2
end
 ```
 2. Для VMware измеить параметры v.vmx["memsize"] или  v.vmx["numvcpus"] соответственно
```sh
config.vm.provider "vmware_desktop" do |v|
  v.vmx["memsize"] = "1024"
  v.vmx["numvcpus"] = "2"
end
```
Выполнить:
```sh
vagrant reload
```

## 7. Команда vagrant ssh из директории, в которой содержится Vagrantfile, позволит вам оказаться внутри виртуальной машины без каких-либо дополнительных настроек.
```sh
vagrant ssh
```
Вывод:
```sh
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-89-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Thu 11 Nov 2021 02:13:16 PM UTC

  System load:  0.06               Processes:             151
  Usage of /:   11.8% of 30.88GB   Users logged in:       0
  Memory usage: 24%                IPv4 address for eth0: 172.16.113.15
  Swap usage:   0%


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
vagrant@vagrant:~$
```

## 8. Ознакомиться с разделами man bash
```sh
man bash
```
1. какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?

HISTSIZE - это количество строк или команд, которые хранятся в памяти в списке истории, пока ваш сеанс bash продолжается.
Строка в man 549

HISTFILESIZE - это количество строк или команд, которые (а) разрешены в файле истории во время запуска сеанса, и (б) сохраняются в файле истории в конце сеанса bash для использования в будущих сеансах.
Строка в man 2025

2. что делает директива ignoreboth в bash?

Опция HISTCONTROL контролирует каким образом список команд сохраняется в истории. Строка в man 534

ignorespace — не сохранять строки начинающиеся с символа <пробел>

ignoredups — не сохранять строки, совпадающие с последней выполненной командой

**ignoreboth** — использовать обе опции ‘ignorespace’ и ‘ignoredups’

erasedups — удалять ВСЕ дубликаты команд с истории

## 9. В каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?
Не совсем поняла сам вопрос, но мне показалось, что речь идет о Brace Expansion.

Используется для создания произвольных строк. Сгенерированные имена могут не существовать. Разделяются запятыми или выражением последовательности. Расширения скоб могут быть вложены.Результаты каждой развернутой строки не сортируются,сохраняется порядок слева направо. 
Например:
```sh
mkdir /usr/local/src/bash/{old,new,dist,bugs}
```
Строка man 689. Другой пример есть в слудующем пункте.

## 10. Основываясь на предыдущем вопросе, как создать однократным вызовом touch 100000 файлов? А получилось ли создать 300000? Если нет, то почему?
1. Создать 100000 файлов
```sh
touch file{1..100000}
```
2. Создать 300000 файлов
```sh
vagrant@vagrant:~/trmp$ touch file{1..300000}
-bash: /usr/bin/touch: Argument list too long
```
Выполняя расширение имени файла, Bash заменяет значения аргументом. Получается что-то вроде:
```sh
touch file1 file2 file3 ... file300000
```
По сути, это создает очень длинный список аргументов командной строки, которые Bash не может обработать.
Данная ошибка возникает, когда количество файлов, расширяемых в качестве аргументов, больше допустимого лимита буфера.

Проверить лимит:
```sh
getconf ARG_MAX
```
Вывод:
```sh
2097152
```

## 11. В man bash поищите по /\[\[. Что делает конструкция [[ -d /tmp ]]
Возвращает статус 0 или 1 в зависимости от оценки условного выражения выражения. В данном случае вернет истину, если файл сущестует и является каталогом.

## 12. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:
```sh
bash is /tmp/new_path_directory/bash
bash is /usr/local/bin/bash
bash is /bin/bash
```
(прочие строки могут отличаться содержимым и порядком) В качестве ответа приведите команды, которые позволили вам добиться указанного вывода или соответствующие скриншоты.

Решение:
```sh
mkdir /tmp/new_path_directory
cp /usr/bin/bash /tmp/new_path_directory
export PATH="/tmp/new_path_directory/:$PATH"
```
Вывод:
```sh
vagrant@vagrant:~$ type -a bash
bash is /tmp/new_path_directory/bash
bash is /usr/bin/bash
bash is /bin/bash
```

## 13. Чем отличается планирование команд с помощью batch и at?
Тогда как cron используется для назначения повторяющихся задач, команда at используется для назначения одноразового задания на заданное время, а команда batch — для назначения одноразовых задач, которые должны выполняться, когда загрузка системы становится меньше 0,8.

1. at
```sh
at time
```
time — время выполнения команды (есть различные парамерты с помощью которых можно задавать time)

2. batch
```sh
batch
```
После ввода команды, выводится приглашение at>

Введите команду, которая должна быть выполнена, а затем нажмите [Enter] и [Ctrl]-[D]

## 14. Завершите работу виртуальной машины чтобы не расходовать ресурсы компьютера и/или батарею ноутбука.
```sh
vagrant suspend
```