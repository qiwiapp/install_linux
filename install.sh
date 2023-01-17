#!/bin/bash




# mongo rep
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 656408E390CFB1F5
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb.list
sudo apt update
# end

#  spawn sudo apt install xtables-addons-common
#  spawn sudo apt install xtables-addons-common nginx git git-lfs certbot mc nodejs npm mongodb-org mongodb-org=4.4.1 mongodb-org-server=4.4.1 mongodb-org-shell=4.4.1 mongodb-org-mongos=4.4.1 mongodb-org-tools=4.4.1
expect -c '
  set timeout -1
  sleep 2
  spawn sudo apt install xtables-addons-common nginx git git-lfs certbot mc nodejs npm mongodb-org mongodb-org=4.4.1 mongodb-org-server=4.4.1 mongodb-org-shell=4.4.1 mongodb-org-mongos=4.4.1 mongodb-org-tools=4.4.1
  expect {
      "Do you want to continue?" {send -- "yes\r"}
  }
  expect eof
'


sudo npm i -g n yarn pm2
sudo n stable
n 16.4.0
hash -r

sudo systemctl start mongod.service

# start change port
echo "Port $1" >> /etc/ssh/sshd_config
sudo service sshd restart
# end

# start ufw
if [ ! -z $2 ] || [ ! -z $3 ] || [ ! -z $4 ] || [ ! -z $5 ]
then
  sudo iptables -A OUTPUT -j ACCEPT
  sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
  sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
fi
# end

# дозволяємо ip
if [ ! -z $2 ]
then
    IFS=';' read -ra ADDR <<< "$2"
    for server_ip in "${ADDR[@]}"; do
      sudo iptables -A INPUT -p tcp -s $server_ip --dport $1 -j ACCEPT
    done
fi
# end
# забороняємо ip
if [ ! -z $3 ]
then
  IFS=';' read -ra ADDR <<< "$3"
    for server_ip in "${ADDR[@]}"; do
        sudo iptables -A INPUT -p tcp -s $server_ip --dport $1 -j DROP
    done
fi
# end


if [ ! -z $4 ] || [ ! -z $5 ]
then
  # start geolib
  mkdir /usr/share/xt_geoip
  sudo chmod +x /usr/lib/xtables-addons/xt_geoip_build
  sudo mkdir /usr/share/xt_geoip
  apt-get install libtext-csv-xs-perl unzip
  /usr/lib/xtables-addons/xt_geoip_dl
  /usr/lib/xtables-addons/xt_geoip_build -D /usr/share/xt_geoip *.csv
  # end
  # дозволяємо geo
  if [ ! -z $4 ]
  then
    iptables -I INPUT -p tcp --dport $1 -m geoip --src-cc $4 -j ACCEPT
#    iptables -I INPUT ! -i lo -p tcp --dport 22 -m geoip ! --src-cc UA,RU -j DROP
#    iptables -I INPUT -i lo -p tcp --dport $1 -m geoip --src-cc $4 -j ACCEPT
#      IFS=';' read -ra ADDR <<< "$4"
#      for country in "${ADDR[@]}"; do
#        iptables -I INPUT ! -i lo -p tcp --dport $1 -m geoip ! --src-cc $country -j DROP
#      done
  fi
  # забороняємо geo
  if [ ! -z $5 ]
  then
    iptables -I INPUT -p tcp --dport $1 -m geoip --src-cc $5 -j DROP
  fi
fi


if [ ! -z $3 ] || [ ! -z $5 ]
then
  sudo iptables -A INPUT -p tcp --dport $1 -j ACCEPT
fi

if [ ! -z $2 ] || [ ! -z $4 ]
then
  sudo iptables -A INPUT -p tcp --dport $1 -j DROP
fi


exit 0