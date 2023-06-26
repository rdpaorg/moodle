# Use the official PHP 8.1 Apache base image
FROM php:8.1-apache

# Set the working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        unzip \
        git \
        curl \
        libicu-dev \
        libxml2-dev \
        libxslt-dev \
        default-mysql-client \
        sudo \
        vim \
        nodejs \
        npm \
        && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite expires headers

# Install PHP extensions
RUN docker-php-ext-install \
    gd \
    intl \
    mysqli \
    opcache \
    soap \
    xsl \
    zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Node.js and NPM
RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
    apt-get install -y nodejs

# Clone the Moodle repository
# RUN git clone --branch MOODLE_X_Y_STABLE --depth 1 https://github.com/moodle/moodle.git .

# Copy the development configuration file
#COPY config-dev.php config.php

# Install Moodle dependencies
RUN composer install --no-dev

# Set the ownership and permissions for Moodle files
RUN chown -R www-data:www-data .
RUN chmod -R 0755 .

# Expose port 80
EXPOSE 80

# Set the default command to start Apache
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
