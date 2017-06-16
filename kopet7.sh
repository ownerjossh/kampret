#DEBIAN SCREPT
apt-get update
cd /usr/bin
#wget http://repo.sufanet.com/debian6/badvpn-udpgw
#chmod 755 badvpn-udpgw
yum install nano
#nano /etc/rc.local
#install tool
cd /usr/bin
wget http://belajar-linux.hol.es/Debian/menu && chmod +x menu
wget http://belajar-linux.hol.es/Debian/badvpn-udpgw && chmod +x badvpn-udpgw
wget http://belajar-linux.hol.es/Debian/banned-user && chmod +x banned-user
wget http://belajar-linux.hol.es/Debian/basename && chmod +x basename
wget http://belajar-linux.hol.es/Debian/benchmark && chmod +x benchmark
wget http://belajar-linux.hol.es/Debian/bmon && chmod +x bmon
wget http://belajar-linux.hol.es/Debian/delete-user-expire && chmod +x delete-user-expire
wget http://belajar-linux.hol.es/Debian/disable-user-expire && chmod +x disable-user-expire
wget http://belajar-linux.hol.es/Debian/dropmon && chmod +x dropmon
wget http://belajar-linux.hol.es/Debian/re-drop && chmod +x re-drop
wget http://belajar-linux.hol.es/Debian/test-speed && chmod +x test-speed
wget http://belajar-linux.hol.es/Debian/user-add && chmod +x user-add
wget http://belajar-linux.hol.es/Debian/user-add-pptp && chmod +x user-add-pptp
wget http://belajar-linux.hol.es/Debian/user-del && chmod +x user-del
wget http://belajar-linux.hol.es/Debian/user-expire-list && chmod +x user-expire-list
wget http://belajar-linux.hol.es/Debian/user-gen && chmod +x user-gen
wget http://belajar-linux.hol.es/Debian/user-limit && chmod +x user-limit
wget http://belajar-linux.hol.es/Debian/user-list && chmod +x user-list
wget http://belajar-linux.hol.es/Debian/user-login && chmod +x user-login
wget http://belajar-linux.hol.es/Debian/user-pass && chmod +x user-pass
wget http://belajar-linux.hol.es/Debian/user-renew && chmod +x user-renew
wget http://belajar-linux.hol.es/Debian/users && chmod +x users
wget http://belajar-linux.hol.es/Debian/user-active-list && chmod +x user-active-list
wget wget http://pencabulmisteri.esy.es/centos/test.py && chmod +x test.py
cd
#screfatcher
#apt-get install lsb-release scrot
#mkdir ~/screenfetch
#cd ~/screenfetch
#wget -O screenfetch 
#'https://raw.github.com/KittyKatt/screenFetch/master/screenfetch-dev'
#chmod +x screenfetch
#./screenfetch
#nano /etc/bash.bashrc
#install dropbear
apt-get update
apt-get install dropbear
nano /etc/default/dropbear
echo "/bin/false" >> /etc/shells
service dropbear restart
netstat -nlpt | grep dropbear
#limit login
#nano /usr/bin/getout
#wget https://belajar-linux.000webhostapp.com/getout && chmod +x /usr/bin/getout
#nano /etc/crontab
cd
#squid proxy
wget http://dedeerik.com/setup-squid.sh
bash setup-squid.sh
#install webmin
apt-get install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python
wget http://prdownloads.sourceforge.net/webadmin/webmin_1.791_all.deb
dpkg --install webmin_1.791_all.deb
nano /etc/webmin/miniserv.conf
service webmin restart
#OCS_PANEL
apt-get update
apt-get update && apt-get -y install mysql-server
mysql_secure_installation
chown -R mysql:mysql /var/lib/mysql/ && chmod -R 755 /var/lib/mysql/
apt-get -y install nginx php5 php5-fpm php5-cli php5-mysql php5-mcrypt
rm /etc/nginx/sites-enabled/default && rm /etc/nginx/sites-available/default
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
mv /etc/nginx/conf.d/vps.conf /etc/nginx/conf.d/vps.conf.backup
wget -O /etc/nginx/nginx.conf "http://script.hostingtermurah.net/repo/blog/ocspanel-debian7/nginx.conf"
wget -O /etc/nginx/conf.d/vps.conf "http://script.hostingtermurah.net/repo/blog/ocspanel-debian7/vps.conf"
sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
useradd -m vps && mkdir -p /home/vps/public_html
rm /home/vps/public_html/index.html && echo "<?php phpinfo() ?>" > /home/vps/public_html/info.php
chown -R www-data:www-data /home/vps/public_html && chmod -R g+rw /home/vps/public_html
service php5-fpm restart && service nginx restart
mysql -u root -p
apt-get -y install git
cd /home/vps/public_html
git init
git remote add origin https://github.com/stevenindarto/OCSPanel.git
git pull origin master
chmod 777 /home/vps/public_html/config
chmod 777 /home/vps/public_html/config/config.ini
chmod 777 /home/vps/public_html/config/route.ini
echo -e "\e[1;33;44m[ belajar-linux.com ]\e[0m"  | tee -a log-install.txt
echo "VPS AUTO REBOOT TIAP 12 JAM, SILAHKAN REBOOT VPS ANDA !"  | tee -a log-install.txt

rm debian7.sh
