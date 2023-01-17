

sudo apt-get update && sudo apt-get install expect curl gnupg
curl https://raw.githubusercontent.com/qiwiapp/install_linux/master/install.sh > install.sh
sudo apt-get install iptables-persistent -y
sudo /sbin/iptables-save

sudo bash install.sh порт 'allow ip1;allow ip2;' 'deny ip1;deny ip2;' 'allow geo1,allow geo2' 'deny geo1,deny geo2'
sudo bash install.sh 2222 '' '' '' ''
sudo bash install.sh 2222 '' '' '' 'UA'
