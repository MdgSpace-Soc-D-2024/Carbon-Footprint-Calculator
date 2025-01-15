#!/bin/bash

source myvenv/bin/activate

# Ensure the script is run as root or with sudo
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root or with sudo."
  exit 1
fi

if ! command -v mysql &> /dev/null; then
  echo "MySQL not found. Installing MySQL Server..."

  #Install MySQL Server
  sudo apt update
  sudo apt install mysql-server -y
  
  # Start MySQL service
  echo "Starting MySQL service..."
  sudo service mysql start

  # Secure MySQL installation
  echo "Securing MySQL installation..."
  sudo mysql_secure_installation

else
  echo "MySQL is installed."
fi


# Prompt for MySQL root password
read -sp "Enter MySQL root password: " MYSQL_ROOT_PASS
echo

# Prompt for database and user details
read -p "Enter new database name: " DB_NAME
read -p "Enter new MySQL user: " DB_USER
read -sp "Enter new MySQL user password: " DB_PASSWORD
echo

# Create the database and user
echo "Creating database and user..."
mysql -u root -p $MYSQL_ROOT_PASS << EOF
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

# Create .env file with database configurations
cfpc=$(pwd)/cfpc_project/cfpc_project
echo "Creating .env file for Django configuration..."
echo "DB_NAME = $DB_NAME" > "$cfpc/.env"
echo "DB_USER = $DB_USER" >> "$cfpc/.env"
echo "DB_PASSWORD = $DB_PASSWORD" >> "$cfpc/.env"
echo "DB_HOST = localhost" >> "$cfpc/.env"
echo "DB_PORT = 3306" >> "$cfpc/.env"

# Install Python dependencies (requires requirements.txt in the repository)
echo "Installing dependencies from requirements.txt..."
pip install -r requirements.txt

# Apply Django migrations
echo "Running Django migrations..."
python manage.py makemigrations
python manage.py migrate

echo "Setup complete! Your MySQL database and Django project are ready to use."