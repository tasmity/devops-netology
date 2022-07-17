# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению

1. Установите ansible версии 2.10 или выше.
```shell
❯ ansible --version
ansible 2.10.4
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/Users/tasmity/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /Library/Frameworks/Python.framework/Versions/3.9/lib/python3.9/site-packages/ansible
  executable location = /Library/Frameworks/Python.framework/Versions/3.9/bin/ansible
  python version = 3.9.0 (v3.9.0:9cf6752276, Oct  5 2020, 11:29:23) [Clang 6.0 (clang-600.0.57)]
```
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.

[ansible_netology ](https://gitlab.com/tasmity/ansible_netology)
3. Скачайте playbook из репозитория с домашним заданием и перенесите его в свой репозиторий.
```shell
commit b6d42810ca396846228a6cd1ccd4dd7fbf1a9032 (HEAD -> main, origin/main, origin/HEAD)
Author: tasmity <tasmity@gmail.com>
Date:   Sun Jul 17 12:20:41 2022 +0300

    add playbook
```


## 1. Основная часть
1. Попробуйте запустить playbook на окружении из test.yml, зафиксируйте какое значение имеет факт some_fact для
указанного хоста при выполнении playbook'a.
```shell
❯ ansible-playbook -i inventory/test.yml site.yml

PLAY [Print os facts] ****************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] **********************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "MacOSX"
}

TASK [Print fact] ********************************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP ***************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
some_fact=12

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на
'all default fact'.
```shell
❯ cat group_vars/all/examp.yml
---
  some_fact: 12%


  
 ❯ cat group_vars/all/examp.yml
---
  some_fact: 'all default fact'%
```
3. Воспользуйтесь подготовленным (используется docker) или создайте собственное окружение для проведения дальнейших
испытаний.
```shell
❯ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS     NAMES
be97fd1d5b38   42a4e3b21923   "/bin/sleep 10000000…"   11 seconds ago   Up 10 seconds             ubuntu
9a51b97f9142   bafa54e44377   "/bin/sleep 10000000…"   32 seconds ago   Up 31 seconds             centos7
```
4. Проведите запуск playbook на окружении из prod.yml. Зафиксируйте полученные значения some_fact для каждого из managed
host.
```shell
❯ ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] ****************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************
ok: [centos7]
ok: [ubuntu]

TASK [Print OS] **********************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ********************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP ***************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

5. Добавьте факты в group_vars каждой из групп хостов так, чтобы для some_fact получились следующие значения: для
deb - 'deb default fact', для el - 'el default fact'.
```shell
❯ cat group_vars/deb/examp.yml
---
  some_fact: "deb default fact"%
  
  
 ❯ cat group_vars/el/examp.yml
---
  some_fact: "el default fact"% 
```

6. Повторите запуск playbook на окружении prod.yml. Убедитесь, что выдаются корректные значения для всех хостов.
```shell
❯ ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] ****************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************
ok: [centos7]
ok: [ubuntu]

TASK [Print OS] **********************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ********************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
7. При помощи ansible-vault зашифруйте факты в group_vars/deb и group_vars/el с паролем netology.
```shell
❯ ansible-vault encrypt group_vars/deb/examp.yml group_vars/el/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful


❯ cat group_vars/deb/examp.yml
$ANSIBLE_VAULT;1.1;AES256
38643463323864316335653834636331656634343466393333363162643836363166623237376662
3964336234626334373138376663396238303037386133370a616334663362383864396230333331
39386235633636343334393036316266343134636366396431396663336262353366323732386638
3531653936396634640a663032306630303032636462316430366364643364613661346136666138
63393133366231393862653831376363383062633264653731653064643464383962623966386463
3933363665353839373235623738613163373639366636306264


❯ cat group_vars/el/examp.yml
$ANSIBLE_VAULT;1.1;AES256
62316637353032636539623035373830626330396562353330313637613363383730396130653237
3138383465366531613138333136636434356339663763660a653132633765353633623731633435
37653039666535616431393336313937613232356533633765643263613536613731313062336537
3133383133643739610a643461333034383161363563363037353036316436633931636561623035
34666435376535653333323465393961393837376434643566393332636634373435376364633432
3533323437303361626437643838366337633333613239666438
```
8. Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь в
работоспособности.
```shell
❯ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] ****************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************
ok: [centos7]
ok: [ubuntu]

TASK [Print OS] **********************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ********************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
9. Посмотрите при помощи ansible-doc список плагинов для подключения. Выберите подходящий для работы на control node.
```shell
❯ ansible-doc --type=connection -l

ansible.netcommon.httpapi      Use httpapi to run command on network appliances
ansible.netcommon.libssh       (Tech preview) Run tasks using libssh for ssh connection
ansible.netcommon.napalm       Provides persistent connection using NAPALM
ansible.netcommon.netconf      Provides a persistent connection using the netconf protocol
ansible.netcommon.network_cli  Use network_cli to run command on network appliances
ansible.netcommon.persistent   Use a persistent unix socket for connection
community.aws.aws_ssm          execute via AWS Systems Manager
community.docker.docker        Run tasks in docker containers
community.docker.docker_api    Run tasks in docker containers
community.general.chroot       Interact with local chroot
community.general.docker       Run tasks in docker containers
community.general.funcd        Use funcd to connect to target
community.general.iocage       Run tasks in iocage jails
community.general.jail         Run tasks in jails
community.general.lxc          Run tasks in lxc containers via lxc python library
community.general.lxd          Run tasks in lxc containers via lxc CLI
community.general.oc           Execute tasks in pods running on OpenShift
community.general.qubes        Interact with an existing QubesOS AppVM
community.general.saltstack    Allow ansible to piggyback on salt minions
community.general.zone         Run tasks in a zone instance
community.kubernetes.kubectl   Execute tasks in pods running on Kubernetes
community.libvirt.libvirt_lxc  Run tasks in lxc containers via libvirt
community.libvirt.libvirt_qemu Run tasks on libvirt/qemu virtual machines
community.okd.oc               Execute tasks in pods running on OpenShift
community.vmware.vmware_tools  Execute tasks inside a VM via VMware Tools
containers.podman.buildah      Interact with an existing buildah container
containers.podman.podman       Interact with an existing podman container
local                          execute on controller
paramiko_ssh                   Run tasks via python ssh (paramiko)
psrp                           Run tasks over Microsoft PowerShell Remoting Protocol
ssh                            connect via ssh client binary
winrm                          Run tasks over Microsoft's WinRM
(END)



local                          execute on controller
```
10. В prod.yml добавьте новую группу хостов с именем local, в ней разместите localhost с необходимым типом подключения.
```shell
❯ cat inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local%
```
11. Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь что факты
some_fact для каждого из хостов определены из верных group_vars.
```shell
❯ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] ****************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************
ok: [localhost]
ok: [centos7]
ok: [ubuntu]

TASK [Print OS] **********************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "MacOSX"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ********************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
12. Заполните README.md ответами на вопросы. Сделайте git push в ветку master. В ответе отправьте ссылку на ваш открытый
репозиторий с изменённым playbook и заполненным README.md.


