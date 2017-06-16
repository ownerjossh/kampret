# install webmin
cd
#wget https://www.dropbox.com/s/9vbc213hm4lnlkc/webmin_1.690_all.deb
wget -O webmin-current.deb "http://www.webmin.com/download/deb/webmin-current.deb"
dpkg -i --force-all webmin-current.deb;
apt-get -y -f install;
rm /root/webmin-current.deb
service webmin restart
service vnstat restart
