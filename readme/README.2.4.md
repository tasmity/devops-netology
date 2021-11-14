# Домашнее задание к занятию «2.4. Инструменты Git»

## 1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.
```sh
git show -s aefea
```
Результат:
```sh
commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
Date:   Thu Jun 18 10:29:58 2020 -0400

    Update CHANGELOG.md
```

## 2. Какому тегу соответствует коммит 85024d3?
```sh
git show -s --oneline 85024d3
```
Результат:
```sh
85024d310 (tag: v0.12.23) v0.12.23
```

## 3. Сколько родителей у коммита b8d720? Напишите их хеши.
```sh
git log --pretty=%P -n 1 b8d720
```
Результат:
```sh
56cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b
```

## 4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.
```sh
git log --oneline v0.12.23..v0.12.24
```
Результат:
```sh
33ff1c03b (tag: v0.12.24) v0.12.24
b14b74c49 [Website] vmc provider links
3f235065b Update CHANGELOG.md
6ae64e247 registry: Fix panic when server is unreachable
5c619ca1b website: Remove links to the getting started guide's old location
06275647e Update CHANGELOG.md
d5f9411f5 command: Fix bug when using terraform login on Windows
4b6d06cc5 Update CHANGELOG.md
dd01a3507 Update CHANGELOG.md
225466bc3 Cleanup after v0.12.23 release
```

## 5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).
1. Ищем коммит
```sh
git log -S"func providerSource("
```
Результат:
```sh
commit 8c928e83589d90a031f811fae52a81be7153e82f
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Thu Apr 2 18:04:39 2020 -0700

    main: Consult local directories as potential mirrors of providers

    This restores some of the local search directories we used to include when
    searching for provider plugins in Terraform 0.12 and earlier. The
    directory structures we are expecting in these are different than before,
    so existing directory contents will not be compatible without
    restructuring, but we need to retain support for these local directories
    so that users can continue to sideload third-party provider plugins until
    the explicit, first-class provider mirrors configuration (in CLI config)
    is implemented, at which point users will be able to override these to
    whatever directories they want.
    ...
```
2. Поиск по коммиту
```sh
git show 8c928e83589d90a031f811fae52a81be7153e82f | grep "func providerSource("
```
Результат:
```sh
+func providerSource(services *disco.Disco) getproviders.Source {
```

## 6. Найдите все коммиты в которых была изменена функция globalPluginDirs.
1. Ищем файл
```sh
git grep "func globalPluginDirs"
```
Результат:
```sh
plugins.go:func globalPluginDirs() []string {
```
1. Поиск по файлу plugins.go
```sh
git log -s --oneline -L :globalPluginDirs:plugins.go
```
Результат:
```sh
78b122055 Remove config.go and update things using its aliases
52dbf9483 keep .terraform.d/plugins for discovery
41ab0aef7 Add missing OS_ARCH dir to global plugin paths
66ebff90c move some more plugin search path logic to command
8364383c3 Push plugin discovery down into command package
```

## 7. Кто автор функции synchronizedWriters?
1. Ищем коммиты
```sh
 git log --oneline -S'synchronizedWriters'
```
Результат:
```sh
bdfea50cc remove unused
fd4f7eb0b remove prefixed io
5ac311e2a main: synchronize writes to VT100-faker on Windows
```
2. Cмотри первый коммит, в котором появилась функция
```sh
git show 5ac311e2a
```
Результат:
```sh
commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Wed May 3 16:25:41 2017 -0700
```