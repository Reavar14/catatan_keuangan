FROM php:8.2-cli

# Instalasi dependensi
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libicu-dev libzip-dev libpq-dev zip unzip git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure intl \
    && docker-php-ext-install pdo_mysql pdo_pgsql gd intl zip

# Gunakan direktori utama
WORKDIR /var/www/html

# Salin semua file ke WORKDIR
COPY . .

# Cari dan jalankan composer install di folder manapun yang memiliki composer.json
RUN find . -name "composer.json" -exec dirname {} \; | xargs -I {} composer install --working-dir={} --no-dev --optimize-autoloader

# Pengaturan permission yang aman
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=80"]