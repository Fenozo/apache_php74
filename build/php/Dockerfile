# PHP
FROM php:7.4-apache

# Modules apache
RUN a2enmod headers deflate expires rewrite
EXPOSE 80

# Composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# RUN composer --version

# Install MS ODBC Driver for SQL Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && apt-get -y --no-install-recommends install msodbcsql17 unixodbc-dev \
    && pecl install sqlsrv \
    && pecl install pdo_sqlsrv \
    && echo "extension=pdo_sqlsrv.so" >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-pdo_sqlsrv.ini \
    && echo "extension=sqlsrv.so" >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-sqlsrv.ini \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
    
# Paquets nécessaires à l'installation de WordPress/WordPlate + utiles
RUN apt-get update && apt-get install -y zip unzip vim

# Extensions MySQL pour PHP/WordPress
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Imagick pour WordPress (https://webapplicationconsultant.com/docker/how-to-install-imagick-in-php-docker/)
RUN apt-get install -y libmagickwand-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN printf "\n" | pecl install imagick
RUN docker-php-ext-enable imagick

# Redémarrage de Apache pour tenir compte des modifications + modules installés
RUN service apache2 restart

# Dossier de travail
WORKDIR /var/www/html/app