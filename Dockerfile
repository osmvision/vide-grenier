# ── Image de production ──────────────────────────────────────────────────────
FROM php:8.2-apache

# Extension PDO MySQL
RUN docker-php-ext-install pdo pdo_mysql

# Copie du code source dans l'image (pas de volume en prod)
COPY src/ /var/www/html/

# Droits corrects pour Apache
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

EXPOSE 80
