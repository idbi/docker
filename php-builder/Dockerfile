# Start from latest PHP 8.3
FROM php:8.3

# Install PDO MySQL extension
RUN docker-php-ext-install pdo_mysql

# Install OpenJDK 17, rsync, git, and zip
RUN apt-get update && \
    apt-get install -y openjdk-17-jre rsync git zip && \
    apt-get clean && \
    java -version && \
    php -v

# Install Composer (latest version from official image)
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
RUN composer --version

# Set the working directory
WORKDIR /app

# Start with bash shell
CMD ["bash"]