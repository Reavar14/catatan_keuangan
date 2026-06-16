FROM php:8.2-cli

# Instalasi dependensi
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libicu-dev libzip-dev libpq-dev zip unzip git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure intl \
    && docker-php-ext-install pdo_mysql pdo_pgsql gd intl zip

# Instal Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 1. Kita PINDHKAN WORKDIR ke dalam folder 'backend'
WORKDIR /var/www/html/backend

# 2. Salin semua file dari folder 'backend' lokal ke WORKDIR container
COPY . .

# 3. Sekarang perintah ini akan berhasil karena file ada di sini
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install --no-dev --optimize-autoloader

# 4. Pengaturan izin
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=80"]