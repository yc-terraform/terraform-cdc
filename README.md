
 ## Как настроить Terraform для Yandex.Cloud

 1. Установить [YC CLI](https://cloud.yandex.com/docs/cli/quickstart)
 2. Добавить переменные для Terraform для аутентификации в Yandex.Cloud

     ```bash
     export YC_TOKEN=$(yc iam create-token)
     export YC_CLOUD_ID=$(yc config get cloud-id)
     export YC_FOLDER_ID=$(yc config get folder-id)
     ```

 ## Требования

 | Name       | Version |
 |------------|---------|
 | terraform  | >= 1.0.0 |
 | yandex     | >= 0.101.0 |
 | random     | > 3  |

 Отдельно установить Docker/Podman для запуска python скрипта https://github.com/nrglv/python-cdc

 ## Провайдер

 | Name   | Version |
 |--------|---------|
 | yandex | 0.122.0 |

 ## Запуск воркшопа

 1. Склонировать оба репозитория
 2. Задеплоить сервисы.
      ```bash
     terraform init
     terraform apply

     ```
не забудьте добавить все в yc cli 
      ```bash
        yc init
        yc config profile create yclabs 
        yc config set federation-id bpf2jqsre4g3oi78gd4o
        yc config set cloud-id ...
        yc config set folder-id ...

     ```
3. Подождать время деплоя, после этого зайдите в консоль и вы увидите 3 базы posgtresql, kafka, clickhouse
4. Уже были предсозданы data transfer endpoint. Создадим репликацию с помощью data transfer от posgtesql в kafka
5. Сделать миграцию в postgresql
  ```sql
  -- Создание таблицы users
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
-- Создание таблицы records
CREATE TABLE IF NOT EXISTS records (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT
);
-- Создание индекса для таблицы users на колонке name
CREATE INDEX IF NOT EXISTS idx_users_name ON users (name);
-- Создание индекса для таблицы records на колонке name
CREATE INDEX IF NOT EXISTS idx_records_name ON records (name);
-- Создание таблицы cdc
CREATE TABLE IF NOT EXISTS cdc (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL
);
-- Запрос на выборку всех данных из таблицы records
SELECT * FROM records;
```
6. Запустить data transfer в консоли yandex cloud из pg в kafka
7. После этого найти имя хоста для postgresql и в python крипте поменять DNS name в файле .env
8. Запустить docker
```bash
docker build -t crud .  
docker run -d -p 8000:8000 crud
```
9. Посмотреть в websql SELECT * FROM records; записи в консоли yandex cloud pg
10. Настроить kafka и clickhouse data transfer 
11. Посмотреть данные в websql в clickhouse