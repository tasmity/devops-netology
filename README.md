# devops-netology
## Репозиторий для курса Netology

### Игнорирование файлов .gitignore каталога terraform
1. Игнорировать все файлы в папке .terraform во всех подкаталогах
```
**/.terraform/*
```
2. Игнарировать файлы с расширением .tfstate
```
*.tfstate
```
3. Игнорировать файлы содержащие .tfstate.
```
*.tfstate.*
```
4. Игнорировать файл crash.log
```
crash.log
```
5. Игнарировать файлы c расширением .tfvars
```
*.tfvars
```
6. Игнорировать файл override.tf
```
override.tf
```
7. Игнорировать файл override.tf.json
```
override.tf.json
```
8. Игнорировать файлы заканчивающиеся на \_override.tf
```
*_override.tf
```
9. Игнорировать файлы заканчивающиеся на \_override.tf.json
```
*_override.tf.json
```
10. Игнорировать файл .terraformrc
```
.terraformrc
```
11. Игнорировать файл terraform.rc
```
terraform.rc
```
