# Stage 1: Build Frontend Vue
FROM node:20-alpine AS frontend-builder
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# Stage 2: Setup Backend Laravel & Satukan Frontend
FROM php:8.2-fpm-alpine
RUN apk add --no-cache nginx supervisor curl libpng-dev libxml2-dev zip unzip
RUN docker-php-ext-install pdo_mysql bcmath gd

# Ambil Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copy seluruh file project
COPY . .

# Pindahkan hasil build Vue ke folder public Laravel agar di-serve bersamaan
COPY --from=frontend-builder /app/frontend/dist /var/www/backend/public

# Masuk ke folder backend untuk install laravel dependencies
WORKDIR /var/www/backend
RUN composer install --no-dev --optimize-autoloader

EXPOSE 80

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=80"]