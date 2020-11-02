function wordpress(){
    echo
    echo "Name of DB "
    read -e namedb
    echo
    
    echo "User of DB"
    read -e userdb
    echo
    
    echo "Password for your DB"
    read -s passdb
    echo
    
    sudo yum -y update httpd
    sudo yum -y install httpd
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --permanent --add-service=https
    sudo firewall-cmd --reload
    sudo systemctl start httpd
    sudo systemctl enable httpd
    sudo yum -y install mariadb-server
    sudo systemctl start mariadb
    sudo systemctl enable mariadb
    
    echo
    echo "Password of DB"
    read -e pass_db
    echo
   
    sudo mysql -u root -p$pass_db mysql -e 
    sudo yum install epel-release yum-utils -y
    sudo yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
    sudo yum install php php-common php-opcache php-mcrypt php-cli php-gd php-curl php-mysql -y
    sudo yum -y install phpmyadmin
    sudo yum -y install rsync
    cd /var/www
    sudo curl https://uk.wordpress.org/latest-uk.tar.gz > wordpress.tar.gz
    sudo tar xzf wordpress.tar.gz
    sudo chmod 777 /var/www/html -R
    sudo rsync -avP wordpress /var/www/html/
    sudo mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php 
    read -r -p "ENTER IP FROM WHICH YOU WILL ENTER IN ADMIN PANEL" ip
    ip_sample=$(grep -E -o -m 1 "([0-9]{1,3}[.]){3}[0-9]{1,3}" /etc/httpd/conf.d/phpMyAdmin.conf | head -1)
    sed -i "s/$ip_sample/$ip/g" /etc/httpd/conf.d/phpMyAdmin.conf
    read -r -p "DBNAME: " dbname
    read -r -p "USERNAME: " username
    read -r -p "DATABASE USER PASSWORD: " userpassword
    sudo mysql -u root -p -e "CREATE DATABASE $dbname"
    sudo mysql -u root -p -e "CREATE USER '$username' IDENTIFIED BY '$userpassword'"
    sudo mysql -u root -p -e "GRANT ALL PRIVILEGES ON $dbname TO '$username'"
    sed -i "s/database_name_here/$dbname/g" /home/wordpress/wp-config.php
    sed -i "s/username_here/$username/g" /home/wordpress/wp-config.php
    sed -i "s/password_here/$userpassword/g" /home/wordpress/wp-config.php
    systemctl restart httpd
}

read -p "Do you want to install Wordpress? " answer
if [[ "$answer" == "y" ]]; then
    wordpress;
elif [[ "$answer" == "n" ]]; then
    exit
