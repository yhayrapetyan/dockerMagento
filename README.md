# 🧹 Magento Docker Setup Guide

This guide will help you set up a Magento 2 project inside Docker. It assumes you already have a Magento 2 project and want to get it running locally using Docker.

---

## 📁 1. Clone Your Magento Project

Clone your existing Magento 2 project into the `src/` directory:

```bash
git clone <your-magento-repo-url> ./src
```

---

## ⚙️ 2. Configure Your Magento Environment

Open `src/app/etc/env.php` and update your DB config to match the `.env` file.

The important part is:

```php
'host' => 'db',
```

You must use `'db'` as the host—this matches the Docker service name and **won’t work otherwise**.

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

### 1. Copy the dump file into the `db` container:

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

### Option 1: Run SQL manually
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
```

You can do this from inside the `db` container or by connecting to MySQL externally.

### Option 2: Use Magento CLI (inside PHP-FPM container)

```bash
docker exec -it phpfpm bash
bin/magento setup:store-config:set --base-url="https://docker_magento.local"
bin/magento setup:store-config:set --base-url-secure="https://docker_magento.local"
exit
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

## ✅ 8. Done!

Now visit:

```
https://docker_magento.local
```

Make sure your local DNS (like `/etc/hosts`) includes:

```
127.0.0.1 docker_magento.local
```
