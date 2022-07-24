
# ID своего облака
variable "yandex_cloud_id" {
  default = "b1g970bjsn1kjlephvs2"
}

# Folder своего облака
variable "yandex_folder_id" {
  default = "b1gnf44jp1gq8a5meplc"
}

# ID своего образа
# ID можно узнать с помощью команды yc compute image list
variable "centos-7-base" {
  default = "fd8bjbem7k1m26lmelcm"
}

// Путь к ключу
variable "yc_key_path" {
  type = string
  default = "./key.json"
}