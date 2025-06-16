# PHP 8.3 + OpenJDK 17 + Composer Docker Image

This image is based on PHP 8.3, with support for MySQL (PDO), OpenJDK 17, Composer, git, rsync, and zip.  
Useful for modern PHP web applications and tools that require Java and advanced utilities.

---

## Features

- PHP 8.3 core and `pdo_mysql` extension for MySQL/MariaDB work
- Composer (latest) for PHP dependency management
- OpenJDK 17 JRE for Java-based tools and pipelines
- Git, rsync, and zip utilities for code management and deployment
- Runs in `/app` working directory by default
- Opens a Bash shell by default (easy for development, CI, or custom CMD)

---

## Usage

### **Build the Image**

```sh
docker build -t php83-jdk17-composer .
```

### **Run an Interactive Shell**

```sh
docker run -it --rm php83-jdk17-composer
```

### **Run Composer or PHP tools**

```sh
docker run -it --rm -v $PWD:/app php83-jdk17-composer composer install
```

---

## Customization

- Add more PHP extensions with `docker-php-ext-install`.
- Add your application files, configs, and `composer.json` to `/app`.
- For production, adjust the `CMD` to run a web server, supervisor, or entrypoint of your app.

---

*Maintained by the IDBI DevOps Team.*