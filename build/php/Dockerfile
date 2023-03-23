#ubuntu version 20.04
FROM ubuntu:20.04
RUN apt update \
    && apt install -y software-properties-common\
    && add-apt-repository ppa:ondrej/php -y \
    && apt-get update \
    && apt-get install php7.4 php7.4-dev php7.4-xml -y --allow-unauthenticated



# Modules apache
RUN a2enmod php7.4 
RUN systemctl restart apache2 


# 2. Install prerequisites (Ubuntu)

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

RUN curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > /etc/apt/sources.list.d/mssql-release.list
#RUN exit
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18
# optional: for bcp and sqlcmd
RUN ACCEPT_EULA=Y apt-get install -y mssql-tools18
RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
RUN source ~/.bashrc
# optional: for unixODBC development headers
RUN apt-get install -y unixodbc-dev

#3. Install the PHP drivers for Microsoft SQL Server (Ubuntu)
RUN pecl install sqlsrv
RUN pecl install pdo_sqlsrv

RUN printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/7.4/mods-available/sqlsrv.ini
RUN printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/7.4/mods-available/pdo_sqlsrv.ini
#RUN exit
RUN phpenmod -v 7.4 sqlsrv pdo_sqlsrv
#4. Install Apache and configure driver loading (Ubuntu)

RUN apt-get install libapache2-mod-php7.4 apache2
RUN a2dismod mpm_event
RUN a2enmod mpm_prefork
RUN a2enmod php7.4
# RUN exit

# Composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# RUN composer --version

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


EXPOSE 80

# Dossier de travail
WORKDIR /var/www/html/app