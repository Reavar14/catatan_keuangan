FROM php:8.2-cli

# Instalasi dependensi
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libicu-dev libzip-dev libpq-dev zip unzip git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure intl \
    && docker-php-ext-install pdo_mysql pdo_pgsql gd intl zip

# Instal Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Tentukan folder kerja di root container
WORKDIR /var/www/html

# Salin isi folder backend ke root container
COPY backend/ .

# Jalankan composer install di root (karena file sekarang ada di sini)
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install --no-dev --optimize-autoloader

# Pengaturan izin
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=80"]