FROM composer:latest as build
WORKDIR /app
COPY . /app
RUN composer install

FROM php:7.4.24-apache
EXPOSE 80
COPY --from=build /app /app
COPY vhost.conf /etc/apache2/sites-available/000-default.conf
RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN chown -R www-data:www-data /app
RUN a2enmod rewrite
