# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

Бывает, что

- общедоступная документация по терраформ ресурсам не всегда достоверна,
- в документации не хватает каких-нибудь правил валидации или неточно описаны параметры,
- понадобиться использовать провайдер без официальной документации,
- может возникнуть необходимость написать свой провайдер для системы используемой в ваших проектах.

## 1. Задача 1

Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда:
<https://github.com/hashicorp/terraform-provider-aws.git>. Просто найдите нужные ресурсы в исходном коде и ответы
на вопросы станут понятны.

1. Найдите, где перечислены все доступные resource и data_source, приложите ссылку на эти строки в коде на гитхабе.
2. Для создания очереди сообщений SQS используется ресурс aws_sqs_queue у которого есть параметр name.
   - С каким другим параметром конфликтует name? Приложите строчку кода, в которой это указано.
   - Какая максимальная длина имени?
   - Какому регулярному выражению должно подчиняться имя?

Ответ:

1. И то и то находится в файле terraform-provider-aws/internal/provider/provider.go:
   - [resource](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#:~:text=ResourcesMap%3A%20map%5Bstring%5D*schema.Resource%7B)
   - [data_source](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#:~:text=DataSourcesMap%3A%20map%5Bstring%5D*schema.Resource%7B)
2. В файле terraform-provider-aws/internal/service/sqs/queue.go: name_prefix
      - [ConflictsWith: []string{"name_prefix"}](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#:~:text=ConflictsWith%3A%20%5B%5Dstring%7B%22name_prefix%22%7D)
      - Максимальна длина 80 символов:

          ```golang
         if len(value) > 80 {
            errors = append(errors, fmt.Errorf("%q cannot be longer than 80 characters", k))
         }
         ```

      - Имя должно подчиняться следующему регулярному выражению:`^[a-zA-Z0-9_-]{1,75}\.fifo$`
  
        ```golang
        if !regexp.MustCompile(`^[a-zA-Z0-9-_]+$`).MatchString(value) {
            errors = append(errors, fmt.Errorf(
                "%q must be composed with only these characters [a-zA-Z0-9-_]: %v", k, value))
        }
        ```

         Здесь я несколько запуталась, так как встретила еще условия, кроме как в validate

         ```golang
            if fifoQueue {
               re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,75}\.fifo$`)
            } else {
               re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,80}$`)
            }

            if !re.MatchString(name) {
                return fmt.Errorf("invalid queue name: %s", name)
            }
         ```
