#!/bin/bash

# This script automates the deployment of a LAMP stack and Laravel application.

# Display initial message
echo "This process is split into parts"
echo "Task 1 executing"

# Update package repositories
sudo apt-get update

# Install necessary packages: Apache, MySQL, PHP, Git
echo "Installing Apache, MySQL, PHP, and other dependencies"
sudo apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql git

# Add PHP repository for installing PHP 8.3
yes | sudo add-apt-repository ppa:ondrej/php
sudo apt update

# Install PHP 8.3 and necessary PHP extensions
sudo apt install php8.3 php8.3-curl php8.3-dom php8.3-mbstring php8.3-xml php8.3-mysql php8.3-sqlite3 zip unzip -y

# Remove PHP 7.4 if installed
sudo apt-get purge php7.4 php7.4-common -y
sudo apt-get update

# Enable Apache modules
sudo a2enmod rewrite
sudo a2enmod php8.3

# Restart Apache server
sudo service apache2 restart
echo "Task 1 done"
echo "--------------------------------------"

# Set up MySQL database and user
MYSQL_COMMANDS=$(cat <<EOF
CREATE USER 'daniel'@'localhost' IDENTIFIED BY 'P@LMOIL';
GRANT ALL PRIVILEGES ON laraveldb.* TO 'daniel'@'localhost';
CREATE DATABASE laraveldb;
SHOW DATABASES;
FLUSH PRIVILEGES;
EOF
)
echo "Setting up MySQL database and user"
echo "$MYSQL_COMMANDS" | sudo mysql -u root

# Install Composer globally
echo "Installing Composer"
cd /usr/bin
curl -sS https://getcomposer.org/installer | sudo php
sudo mv composer.phar composer

# Install Laravel application
echo "Cloning Laravel application from GitHub"
cd /var/www/
sudo git clone https://github.com/laravel/laravel.git
cd laravel
echo "Installing Laravel dependencies"
composer install --optimize-autoloader --no-dev --no-interaction
sudo composer update -y
sudo cp .env.example .env

# Configure Laravel application settings in .env file
DB_HOST="localhost"
DB_DATABASE="laraveldb"
DB_USERNAME="daniel"
DB_PASSWORD="P@LMOIL"
ENV_FILE="/var/www/laravel/.env"
sudo sed -i "s/DB_HOST=.*/DB_HOST=${DB_HOST}/" ${ENV_FILE}
sudo sed -i "s/DB_DATABASE=.*/DB_DATABASE=${DB_DATABASE}/" ${ENV_FILE}
sudo sed -i "s/DB_USERNAME=.*/DB_USERNAME=${DB_USERNAME}/" ${ENV_FILE}
sudo sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=${DB_PASSWORD}/" ${ENV_FILE}

# Generate Laravel application key
sudo php artisan key:generate

# Set appropriate ownership for Laravel directories
echo "Setting ownership permissions for Laravel directories"
sudo chown -R www-data storage
sudo chown -R www-data bootstrap/cache

# Configure Apache virtual host for Laravel
echo "Configuring Apache virtual host for Laravel application"
cd /etc/apache2/sites-available/
sudo touch laravel.conf
sudo chown vagrant:vagrant laravel.conf
chmod +w laravel.conf
sudo cat<<EOF >laravel.conf
<VirtualHost *:80>
ServerName daniel@localhost
DocumentRoot /var/www/laravel/public

    <Directory /var/www/laravel/public>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/laravel-error.log
    CustomLog \${APACHE_LOG_DIR}/laravel-access.log combined

</VirtualHost>
EOF

# Disable default Apache site and enable Laravel site
sudo a2dissite 000-default.conf
sudo a2ensite laravel.conf
apache2ctl -t
sudo systemctl restart apache2

# Create SQLite database file for Laravel
echo "Creating SQLite database for Laravel"
sudo touch /var/www/laravel/database/database.sqlite
sudo chown www-data:www-data /var/www/laravel/database/database.sqlite

# Run Laravel migrations and seed the database
cd /var/www/laravel/
sudo php artisan migrate
sudo php artisan db:seed

# Restart Apache server for changes to take effect
sudo systemctl restart apache2

echo "LAMP stack deployment completed!"
