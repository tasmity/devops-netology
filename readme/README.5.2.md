# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## 1. Задача 1
+ Опишите своими словами основные преимущества применения на практике IaaC паттернов.

Ответ:

Паттерны — это один из инструментов, который помогает сэкономить время и сделать более качественное
решение.
Позволяет раннее выявление дефектов, что сокращает стоимость их исправления. Так же дает возможность небольших апдейтов,
что позволяет легко откатится на предыдущую версию, исправить дефекты и перезапустить сборку, уже с учетом текущих
исправлений. Так же дают возможность автоматизировать процесс сборки и раскатки, позволяя запускать данный процесс без
стороннего вмешательства.

Например, дергать джоб сборки jenkins, при получении нового кода в master ветки репозитория,
а при успешной сборке, автоматически загружать артефакт например в nexus и дергать джоб раскатки, который в прохождении
от стенда к стенду, точно так же позволяет автоматизировать процесс и в зависимости от успешности прохождения стенда,
запускать раскатку и тестирование на следующем стенде или производить откат среды.

Данный процесс не совсем применим (у нас) для PSI и PROD стендах, так как требует ручного запуска, официального
согласования выхода релиза и документального подтверждения прохождения всех тестов от службы безопасности. Но в конечном
итоге, по ручному запуску, все остальные действия по раскатке на промышленные стенды могут проходить в таком же 
автоматическом режиме.

+ Какой из принципов IaaC является основополагающим?

Ответ:
> Идемпоте́нтность — это свойство объекта или операции, при повторном выполнении которой мы получаем результат
> идентичный предыдущему и всем последующим выполнениям.

## 2. Задача 2
+ Чем Ansible выгодно отличается от других систем управление конфигурациями?

 Ответ:

Ansible, пожалуй, самый простой из существующих программных средств управления конфигурацией. 
Поскольку Ansible разработан специально для простоты использования, это относительно простой программный инструмент.
Создатели могут похвастаться своей способностью легко ускорить работу, упростить совместную работу и легко
интегрировать технологии.

Ansible использует язык YAML для всех команд. Этот язык относительно легко выучить, независимо от
предыдущего опыта или его отсутствия.

Традиционно «безагентное» развертывание через SSH, которое стандартно работает на большинстве серверов
(теперь доступна агентская модель).

+ Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

Ответ:

В рамках метода push программное обеспечение для подготовки, такое как Ansible, отправляет артефакты и приложения
непосредственно на интересующие устройства. Программное обеспечение инициализации также настроит машины,
например, открыв порты для доступа с других машин.

Метод pull устанавливает агент на виртуальную машину или физический компьютер. Затем агент взаимодействует с сервером,
чтобы получить артефакты и приложения, которые он хочет установить. Кроме того, агент настроит конкретный
хост-компьютер в соответствии с набором правил конфигурации.

Популярность технологии push растет, поскольку она позволяет создавать и выделять виртуальные машины из единой точки
выполнения. Но все еще существует много работающих систем, в которых используется метод pull.

Я бы точно предпочла метод push, хотя бы по той причине, что не имею никакого опыта работы с pull методом.

## 3. Задача 3
Установить на личный компьютер:
 + VirtualBox
 + Vagrant
 + Ansible

Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.

Ответ:
 ```shell
 ❯  vboxmanage --version
6.1.30r148432
❯ virtualbox --help | head -n 1 | awk '{print $NF}'
v6.1.30

❯ vagrant -v
Vagrant 2.2.19

❯ ansible --version
ansible 2.10.4
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/Users/tasmity/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /Library/Frameworks/Python.framework/Versions/3.9/lib/python3.9/site-packages/ansible
  executable location = /Library/Frameworks/Python.framework/Versions/3.9/bin/ansible
  python version = 3.9.0 (v3.9.0:9cf6752276, Oct  5 2020, 11:29:23) [Clang 6.0 (clang-600.0.57)]
 ```

## 4. Задача 4
Воспроизвести практическую часть лекции самостоятельно.
+ Создать виртуальную машину.
+ Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```shell
docker ps
```

Ответ:
```shell
❯ export VAGRANT_DEFAULT_PROVIDER=virtualbox

❯ vagrant box add bento/ubuntu-20.04 --provider=virtualbox --force
==> box: Loading metadata for box 'bento/ubuntu-20.04'
    box: URL: https://vagrantcloud.com/bento/ubuntu-20.04
==> box: Adding box 'bento/ubuntu-20.04' (v202112.19.0) for provider: virtualbox
    box: Downloading: https://vagrantcloud.com/bento/boxes/ubuntu-20.04/versions/202112.19.0/providers/virtualbox.box
==> box: Successfully added box 'bento/ubuntu-20.04' (v202112.19.0) for 'virtualbox'!

❯ vagrant box list
bento/ubuntu-20.04 (virtualbox, 202107.28.0)
bento/ubuntu-20.04 (virtualbox, 202112.19.0)
bento/ubuntu-20.04 (vmware_desktop, 202110.25.0)
hashicorp/bionic64 (virtualbox, 1.0.282)
hashicorp/bionic64 (vmware_desktop, 1.0.282)

❯ vi Vagrantfile
ISO = "bento/ubuntu-20.04"
NET = "192.168.56."
DOMAIN = ".netology"
HOST_PREFIX = "server"
INVENTORY_PATH = "../ansible/inventory"
servers = [ {
    :hostname => HOST_PREFIX + "1" + DOMAIN,
    :ip => NET + "11",
    :ssh_host => "20011",
    :ssh_vm => "22",
    :ram => 1024,
    :core => 1
  }
]

Vagrant.configure(2) do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: false
  servers.each do |machine|
    config.vm.define machine[:hostname] do |node|
      node.vm.box = ISO
      node.vm.hostname = machine[:hostname]
      node.vm.network "private_network", ip: machine[:ip]
      node.vm.network :forwarded_port, guest: machine[:ssh_vm], host: machine[:ssh_host]
      node.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", machine[:ram]]
        vb.customize ["modifyvm", :id, "--cpus", machine[:core]]
        vb.name = machine[:hostname]
      end
      node.vm.provision "ansible" do |setup|
        setup.inventory_path = INVENTORY_PATH
        setup.playbook = "../ansible/provision.yml"
        setup.become = true
        setup.extra_vars = { ansible_user: 'vagrant' }
      end
    end
  end
end
 
❯ vi inventory
[nodes:children]
manager

[manager]
server1.netology ansible_host=127.0.0.1 ansible_port=20011 ansible_user=vagrant


❯ vi ansible.cfg
[defaults]
inventory=./inventory
deprecation_warnings=False
command_warnings=False
ansible_port=22
interpreter_python=/usr/bin/python3

❯ vi provision.yml
---

  - hosts: nodes
    become: yes
    become_user: root
    remote_user: vagrant

    tasks:
      - name: Create directory for ssh-keys
        file: state=directory mode=0700 dest=/root/.ssh/

      - name: Adding rsa-key in /root/.ssh/authorized_keys
        copy: src=~/.ssh/id_rsa.pub dest=/root/.ssh/authorized_keys owner=root mode=0600
        ignore_errors: yes

      - name: Checking DNS
        command: host -t A google.com

      - name: Installing tools
        apt: >
          package={{ item }}
          state=present
          update_cache=yes
        with_items:
          - git
          - curl

      - name: Installing docker
        shell: curl -fsSL get.docker.com -o get-docker.sh && chmod +x get-docker.sh && ./get-docker.sh

      - name: Add the current user to docker group
        user: name=vagrant append=yes groups=docker


❯ vagrant up
Bringing machine 'server1.netology' up with 'virtualbox' provider...
==> server1.netology: Importing base box 'bento/ubuntu-20.04'...
==> server1.netology: Matching MAC address for NAT networking...
==> server1.netology: Checking if box 'bento/ubuntu-20.04' version '202112.19.0' is up to date...
==> server1.netology: Setting the name of the VM: server1.netology
==> server1.netology: Clearing any previously set network interfaces...
==> server1.netology: Preparing network interfaces based on configuration...
    server1.netology: Adapter 1: nat
    server1.netology: Adapter 2: hostonly
==> server1.netology: Forwarding ports...
    server1.netology: 22 (guest) => 20011 (host) (adapter 1)
    server1.netology: 22 (guest) => 2222 (host) (adapter 1)
==> server1.netology: Running 'pre-boot' VM customizations...
==> server1.netology: Booting VM...
==> server1.netology: Waiting for machine to boot. This may take a few minutes...
    server1.netology: SSH address: 127.0.0.1:2222
    server1.netology: SSH username: vagrant
    server1.netology: SSH auth method: private key
    server1.netology:
    server1.netology: Vagrant insecure key detected. Vagrant will automatically replace
    server1.netology: this with a newly generated keypair for better security.
    server1.netology:
    server1.netology: Inserting generated public key within guest...
    server1.netology: Removing insecure key from the guest if it's present...
    server1.netology: Key inserted! Disconnecting and reconnecting using new SSH key...
==> server1.netology: Machine booted and ready!
==> server1.netology: Checking for guest additions in VM...
==> server1.netology: Setting hostname...
==> server1.netology: Configuring and enabling network interfaces...
==> server1.netology: Mounting shared folders...
    server1.netology: /vagrant => /Users/tasmity/.vagrant
==> server1.netology: Running provisioner: ansible...
    server1.netology: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.netology]

TASK [Create directory for ssh-keys] *******************************************
ok: [server1.netology]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
changed: [server1.netology]

TASK [Checking DNS] ************************************************************
changed: [server1.netology]

TASK [Installing tools] ********************************************************
ok: [server1.netology] => (item=['git', 'curl'])

TASK [Installing docker] *******************************************************
changed: [server1.netology]

TASK [Add the current user to docker group] ************************************
changed: [server1.netology]

PLAY RECAP *********************************************************************
server1.netology           : ok=7    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

❯ vagrant ssh
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed 19 Jan 2022 04:57:01 PM UTC

  System load:  0.26               Users logged in:          0
  Usage of /:   13.4% of 30.88GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 24%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.56.11
  Processes:    119


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Wed Jan 19 16:56:15 2022 from 10.0.2.2

vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

```
