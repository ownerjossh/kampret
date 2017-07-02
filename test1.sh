#CENTOS SCRIPT

#!/bin/bash

# initialisasi var
OS=`uname -p`;

# go to root
cd

# disable se linux
echo 0 > /selinux/enforce
sed -i 's/SELINUX=enforcing/SELINUX=disable/g'  /etc/sysconfig/selinux

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service sshd restart

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.d/rc.local

# install wget and curl
yum -y install wget curl

# setting repo
wget https://raw.githubusercontent.com/ownerjossh/master-centos6/master/epel-release-6-8.noarch.rpm
wget https://raw.githubusercontent.com/ownerjossh/master-centos6/master/remi-release-6.rpm
rpm -Uvh epel-release-6-8.noarch.rpm
rpm -Uvh remi-release-6.rpm

if [ "$OS" == "x86_64" ]; then
  wget https://raw.githubusercontent.com/ownerjossh/master-centos6/master/rpmforge.rpm
  rpm -Uvh rpmforge.rpm
else
  wget https://raw.githubusercontent.com/ownerjossh/master-centos6/master/rpmforge.rpm
  rpm -Uvh rpmforge.rpm
fi

sed -i 's/enabled = 1/enabled = 0/g' /etc/yum.repos.d/rpmforge.repo
sed -i -e "/^\[remi\]/,/^\[.*\]/ s|^\(enabled[ \t]*=[ \t]*0\\)|enabled=1|" /etc/yum.repos.d/remi.repo
rm -f *.rpm

# remove unused
yum -y remove sendmail;
yum -y remove httpd;
yum -y remove cyrus-sasl

yum update
cd /usr/bin
#wget http://repo.sufanet.com/centos6/badvpn-udpgw
#chmod 755 badvpn-udpgw

yum install nano
#nano /etc/rc.local

# install webserver
yum -y install nginx php-fpm php-cli
service nginx restart
service php-fpm restart
chkconfig nginx on
chkconfig php-fpm on

# install essential package
yum -y install rrdtool screen iftop htop nmap bc nethogs openvpn vnstat ngrep mtr git zsh mrtg unrar rsyslog rkhunter mrtg net-snmp net-snmp-utils expect nano bind-utils
yum -y groupinstall 'Development Tools'
yum -y install cmake

yum -y --enablerepo=rpmforge install axel sslh ptunnel unrar

# matiin exim
service exim stop
chkconfig exim off


yum update
cd /usr/bin
#wget http://repo.sufanet.com/centos6/badvpn-udpgw
#chmod 755 badvpn-udpgw


# cron test
service crond start
chkconfig crond on
service crond stop
echo "*/30 * * * * root service dropbear restart" > /etc/cron.d/dropbear
echo "00 23 * * * root /usr/bin/disable-user-expire" > /etc/cron.d/disable-user-expire
echo "0 */24 * * * root /sbin/reboot" > /etc/cron.d/reboot
#echo "@reboot root /usr/bin/user-limit" > /etc/cron.d/user-limit
#echo "@reboot root /usr/bin/autokill" > /etc/cron.d/autokill
#sed -i '$ i\screen -AmdS check /root/autokill' /etc/rc.local
service crond start
chkconfig crond on


# set time GMT +7 test
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime


# install screenfetch test
cd
wget https://raw.githubusercontent.com/ownerjossh/master-centos6/master/screenfetch-dev
mv screenfetch-dev /usr/bin/screenfetch
chmod +x /usr/bin/screenfetch
echo "clear" >> .bash_profile
echo "screenfetch" >> .bash_profile

# install webserver
cd
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/ownerjossh/kampret/master/pool/nginx.conf"
sed -i 's/www-data/nginx/g' /etc/nginx/nginx.conf
mkdir -p /home/vps/public_html
echo "<pre>Setup by -JoSSH TEAM- https://facebook.com/www.sutriez</pre>" > /home/vps/public_html/index.html
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
rm /etc/nginx/conf.d/*
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/ownerjossh/kampret/master/pool/vps.conf"
sed -i 's/apache/nginx/g' /etc/php-fpm.d/www.conf
chmod -R +rx /home/vps
service php-fpm restart
service nginx restart



# install openvpn test
wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/ownerjossh/master-centos6/master/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/ownerjossh/master-centos6/master/1194-centos.conf"
if [ "$OS" == "x86_64" ]; then
  wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/ownerjossh/master-centos6/master/1194-centos.conf"
fi
wget -O /etc/iptables.up.rules "https://raw.githubusercontent.com/ownerjossh/master-centos6/master/iptables.up.rules"
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.d/rc.local
MYIP=`dig +short myip.opendns.com @resolver1.opendns.com`;
MYIP2="s/xxxxxxxxx/$MYIP/g";
sed -i $MYIP2 /etc/iptables.up.rules;
sed -i 's/venet0/eth0/g' /etc/iptables.up.rules
iptables-restore < /etc/iptables.up.rules
sysctl -w net.ipv4.ip_forward=1
sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/sysctl.conf
service openvpn restart
chkconfig openvpn on
cd

# configure openvpn client config test
cd /etc/openvpn/
wget -O /etc/openvpn/1194-client.ovpn "https://raw.githubusercontent.com/ownerjossh/master-centos6/master/open-vpn.conf"
sed -i $MYIP2 /etc/openvpn/1194-client.ovpn;
PASS=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1`;
useradd -M -s /bin/false JoSSH
echo "JoSSH:$PASS" | chpasswd
echo "JoSSH" > pass.txt
echo "$PASS" >> pass.txt
tar cf client.tar 1194-client.ovpn pass.txt
cp client.tar /home/vps/public_html/
cp 1194-client.ovpn /home/vps/public_html/
cd


# install mrtg test
cd /etc/snmp/
wget -O /etc/snmp/snmpd.conf "https://raw.githubusercontent.com/ownerjossh/master-centos6/master/snmpd.conf"
wget -O /root/mrtg-mem.sh "https://raw.githubusercontent.com/ownerjossh/master-centos6/master/mrtg-mem.sh"
chmod +x /root/mrtg-mem.sh
service snmpd restart
chkconfig snmpd on
snmpwalk -v 1 -c public localhost | tail
mkdir -p /home/vps/public_html/mrtg
cfgmaker --zero-speed 100000000 --global 'WorkDir: /home/vps/public_html/mrtg' --output /etc/mrtg/mrtg.cfg public@localhost
curl "https://raw.githubusercontent.com/ownerjossh/master-centos6/master/mrtg.conf" >> /etc/mrtg/mrtg.cfg
sed -i 's/WorkDir: \/var\/www\/mrtg/# WorkDir: \/var\/www\/mrtg/g' /etc/mrtg/mrtg.cfg
sed -i 's/# Options\[_\]: growright, bits/Options\[_\]: growright/g' /etc/mrtg/mrtg.cfg
indexmaker --output=/home/vps/public_html/mrtg/index.html /etc/mrtg/mrtg.cfg
echo "0-59/5 * * * * root env LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg" > /etc/cron.d/mrtg
LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg
LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg
LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg


# setting port ssh test
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port  22/g' /etc/ssh/sshd_config
service sshd restart
chkconfig sshd on

# install dropbear test
yum -y install dropbear
echo "OPTIONS=\"-p 109 -p 110 -p 443 -p 22507 -p 2017\"" > /etc/sysconfig/dropbear
echo "/bin/false" >> /etc/shells
service dropbear restart
chkconfig dropbear on

# setting vnstat test
vnstat -u -i eth0
echo "MAILTO=root" > /etc/cron.d/vnstat
echo "*/5 * * * * root /usr/sbin/vnstat.cron" >> /etc/cron.d/vnstat
service vnstat restart
chkconfig vnstat on

# install vnstat gui test
cd /home/vps/public_html/
wget https://raw.githubusercontent.com/ownerjossh/master-centos6/master/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i "s/\$iface_list = array('eth0', 'sixxs');/\$iface_list = array('eth0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
cd

# install fail2ban test
yum -y install fail2ban
service fail2ban restart
chkconfig fail2ban on

# install webmin test
cd
wget http://prdownloads.sourceforge.net/webadmin/webmin-1.670-1.noarch.rpm
rpm -i webmin-1.670-1.noarch.rpm;
rm webmin-1.670-1.noarch.rpm
service webmin restart
chkconfig webmin on

#limit IP asli
iptables -A INPUT -p tcp --syn --dport 443 -m connlimit --connlimit-above 2 -j REJECT
service iptables save
service iptables restart
chkconfig iptables on
iptables -n -L


# install squid test
yum -y install squid
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/ownerjossh/master-centos6/master/squid-centos.conf"
service squid restart
service squid stop
sed -i $MYIP2 /etc/squid/squid.conf;
chkconfig squid on


cd /usr/bin
wget http://belajar-linux.hol.es/Centos/menu && chmod +x menu
wget http://belajar-linux.hol.es/Centos/badvpn-udpgw && chmod +x badvpn-udpgw
wget https://raw.githubusercontent.com/ownerjossh/kampret/master/pool/banned-user.sh && chmod +x banned-user
wget http://belajar-linux.hol.es/Centos/basename && chmod +x basename
wget https://raw.githubusercontent.com/ownerjossh/kampret/master/pool/benchmark.sh && chmod +x benchmark
wget http://belajar-linux.hol.es/Centos/bmon && chmod +x bmon
wget http://belajar-linux.hol.es/Centos/delete-user-expire && chmod +x delete-user-expire
wget http://belajar-linux.hol.es/Centos/disable-user-expire && chmod +x disable-user-expire
wget https://raw.githubusercontent.com/ownerjossh/kampret/master/pool/dropmon.sh && chmod +x dropmon
wget http://belajar-linux.hol.es/Centos/re-drop && chmod +x re-drop
wget http://belajar-linux.hol.es/Centos/test-speed && chmod +x test-speed
wget http://belajar-linux.hol.es/Centos/user-add && chmod +x user-add
wget http://belajar-linux.hol.es/Centos/user-add-pptp && chmod +x user-add-pptp
wget http://belajar-linux.hol.es/Centos/user-del && chmod +x user-del
wget http://belajar-linux.hol.es/Centos/user-expire-list && chmod +x user-expire-list
wget https://raw.githubusercontent.com/ownerjossh/kampret/master/pool/trial.sh && chmod +x trial
wget https://raw.githubusercontent.com/iswant/7v/master/menu/userlimit2.sh && chmod +x user-limit
wget https://raw.githubusercontent.com/ownerjossh/kampret/master/pool/user-list.sh && chmod +x user-list
wget https://raw.githubusercontent.com/ownerjossh/kampret/master/pool/user-login.sh && chmod +x user-login
wget http://belajar-linux.hol.es/Centos/user-pass && chmod +x user-pass
wget http://belajar-linux.hol.es/Centos/user-renew && chmod +x user-renew
wget http://belajar-linux.hol.es/Centos/users && chmod +x users
wget https://raw.githubusercontent.com/ownerjossh/master-centos6/master/perintah/ps_mem.py && chmod +x ps-mem
wget http://belajar-linux.hol.es/Centos/user-active-list && chmod +x user-active-list
wget https://raw.githubusercontent.com/ownerjossh/master-centos6/master/perintah/ps_mem.py && chmod +x ps-mem.py
cd


# finalisasi
chown -R nginx:nginx /home/vps/public_html
service nginx start
service php-fpm start
service vnstat restart
service openvpn restart
service snmpd restart
service sshd restart
service dropbear restart
service fail2ban restart
service squid restart
service webmin restart
service crond start
chkconfig crond on

echo -e "\e[1;33;44m[ https://facebook.com/www.sutriez ]\e[0m"  | tee -a log-install.txt
echo "VPS AUTO REBOOT TIAP JAM 00:00, SILAHKAN REBOOT VPS ANDA !"  | tee -a log-install.txt

rm centos6.sh
