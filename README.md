

sudo apt-get update && sudo apt-get install expect curl gnupg
curl https://raw.githubusercontent.com/qiwiapp/install_linux/master/install.sh > install.sh
sudo apt-get install iptables-persistent -y
sudo /sbin/iptables-save

                         1          2                 3                    4                      5                     6
sudo bash install.sh ssh_port 'allow_tcp_port' 'allow ip1;allow ip2;' 'deny ip1;deny ip2;' 'allow geo1,allow geo2' 'deny geo1,deny geo2'
sudo bash install.sh 2222 '5050;6060;8080;80;443;' '' '' '' ''
sudo bash install.sh 2222 '' '' '' 'RU'
