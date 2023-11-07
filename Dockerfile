# Use the PHP 8.1 FPM base image
FROM php:8.1-fpm

# Install required packages and dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring

# Set the working directory in the container
WORKDIR /app

# Copy the composer.json and composer.lock files for dependency installation
COPY composer.json .
COPY composer.lock .

# Install PHP dependencies without running scripts (for production use)
RUN composer install --no-scripts --no-autoloader

# Copy the rest of your application files
COPY . .

# Generate Composer's autoloader and run any necessary scripts
RUN composer dump-autoload
RUN php artisan key:generate

# Expose port 9000 (the default PHP-FPM port)
EXPOSE 9000

# Use the default CMD for PHP-FPM
CMD ["php-fpm"]

