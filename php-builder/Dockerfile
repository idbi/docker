# Start from latest PHP 8.3
FROM php:8.3-cli

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    libxslt-dev \
    libwebp-dev \
    libavif-dev \
    libgmp-dev \
    libldap2-dev \
    libpq-dev \
    libsqlite3-dev \
    libcurl4-openssl-dev \
    libicu-dev \
    libsodium-dev \
    unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install basic PHP extensions
RUN docker-php-ext-install pdo_mysql curl gd mbstring bcmath intl zip soap pcntl sockets exif sodium

# Install Composer (latest version from official image)
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
RUN composer --version

# Set the working directory
WORKDIR /app

# Start with bash shell
CMD ["bash"]
