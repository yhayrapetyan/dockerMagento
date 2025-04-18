# 🧹 Magento2-Docker Setup Guide

This guide will help you set up a Magento 2 project inside Docker. It assumes you already have a Magento 2 project and want to get it running locally using Docker.
### The instructions and configurations are generally fine, but there might be some cases where errors could occur (especially Nginx). If you face any issues, please feel free to open an issue.

---

## 📁 1. Clone Your Magento Project

Clone your existing Magento 2 project into the `src/` directory:

```bash
git clone <your-magento-repo-url> ./src
```

---

## ⚙️ 2. Preconfiguration

Open `src/app/etc/env.php` and update your DB config to match the `.env` file.

The important part is:

```php
'host' => 'db',
```

You must use `'db'` as the host—this matches the Docker service name and **won’t work otherwise**.

### ⚠️ Depending on whether you want to use an existing external volume or create a new one, uncomment the appropriate volume section in the docker-compose.yml file.
### And don't forget to update "db" service
```yaml
volumes:
    - new_volume_name:/var/lib/mysql
```
## If you are using existing volume ignore 5 and 6 steps

---

## 🚩 3. Disable Local Services

Before using Docker, you should stop services on your machine that conflict with the ones inside Docker:

```bash
sudo systemctl stop mysql
sudo systemctl stop apache2
sudo systemctl stop nginx
sudo systemctl stop elasticsearch
sudo systemctl stop postfix
```

---

## 🐳 4. Start Docker Containers

Start everything using:

```bash
docker compose up --build
```

---
## 📂 5. Import Your Database

```bash
docker cp path/to/dump.sql db:/dump.sql
```

### 2. Enter the `db` container:

```bash
docker exec -it db bash
```

### 3. Run the SQL import:

```bash
mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" < /dump.sql
```

Then:

```bash
exit
```

---

## 🔧 6. Update Base URLs and Elasticsearch Host

#### You can do this from inside the `db` container or by connecting to MySQL externally (It'll be much easier).
### If you want to update from inside `db` container
### 1. Enter the `db` container:

```bash
docker exec -it db bash
```

### 2. Run the SQL import:

```bash
mysql -u "$MYSQL_USER" -p
```

```sql
UPDATE core_config_data SET value = 'https://docker_magento.local' WHERE path = 'web/unsecure/base_url';
UPDATE core_config_data SET value = 'https://docker_magento.local' WHERE path = 'web/secure/base_url';
UPDATE core_config_data SET value = 'elasticsearch' WHERE path = 'catalog/search/elasticsearch7_server_hostname';
UPDATE core_config_data SET value = 'elasticsearch' WHERE path = 'catalog/search/elasticsearch_server_host';
```




---

## 🧹 7. Magento Setup Commands

Access the `phpfpm` container:

```bash
docker exec -it phpfpm bash
```

Run the following:

```bash
composer install
bin/magento setup:upgrade
bin/magento cache:flush
bin/magento indexer:reindex
```

Then:

```bash
exit
```

---
## 📬 Mail (Mailpit)

Mailpit is already configured in the Docker setup to capture outgoing emails for local development.

To view the emails, open the Mailpit web interface at:  
http://localhost:8025/

If you want to use another service don't forget to update php.ini
```
[mailpit]
sendmail_path = "/usr/bin/msmtp -t"
```

## ✅ 8. Done!

Now visit:

```
https://docker_magento.local
```

Make sure your local DNS (like `/etc/hosts`) includes:

```
127.0.0.1 docker_magento.local
```

---

### 📌 Possible Problems & Notes

- Sometimes you may need to run the following commands inside the `phpfpm` container:
  ```bash
  composer dump-autoload
  bin/magento setup:static-content:deploy -f
  ```
  In the Magento admin panel, some pages (like the products grid) may load slowly or not render completely on the first attempt.
  If that happens, simply refresh the page to load the data correctly.
