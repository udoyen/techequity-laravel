FROM composer:latest as build
WORKDIR /app
COPY . /app
RUN composer install

FROM php:8.1.0-apache
EXPOSE 8080
COPY --from=build /app /var/www
COPY docker/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY .env /var/www/.env
RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN chmod 777 -R /var/www/storage/ && \
    echo "Listen 8080" >> /etc/apache2/ports.conf && \
    chown -R www-data:www-data /var/www/ && \
    a2enmod rewrite
