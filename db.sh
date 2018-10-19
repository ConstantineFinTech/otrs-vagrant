INSTALL_DIR=/data/www/otrs
echo "Copying config file"
sudo mv Config.pm $INSTALL_DIR/Kernel/Config.pm
sudo chown otrs:www-data $INSTALL_DIR/Kernel/Config.pm
sudo chmod 770 $INSTALL_DIR/Kernel/Config.pm

echo "Installing database..."
cd /tmp
wget https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-3.noarch.rpm
sudo rpm -ivh pgdg-centos95-9.5-3.noarch.rpm
sudo yum -y update
sudo yum install -y postgresql95-server.x86_64
su -c " /usr/pgsql-9.5/bin/initdb -D /var/lib/pgsql/9.5/data" -s /bin/bash postgres
sudo systemctl start postgresql-9.5.service
sudo systemctl enable postgresql-9.5.service

su -c "createuser otrs" -s /bin/bash postgres
su -c "echo \"alter user otrs with encrypted password 'otrs-ioa';\"| psql " -s /bin/bash postgres
su -c "createdb otrs -O otrs" -s /bin/bash postgres
su -c "echo otrs.sql | psql otrs" -s /bin/bash postgres
