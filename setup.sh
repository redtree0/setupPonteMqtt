#!/bin/bash


echo "=========================================="
echo "Node.js Install on CentOS"
echo "=========================================="
echo "yum update"
sudo yum update

sleep 1
echo "setup repository nodejs 8"
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -

sleep 1
echo "install nodejs "
sudo yum -y install nodejs

sleep 1
echo "nodejs build tools install"
sudo yum install gcc-c++ make -y

sleep 1

echo "=========================================="
echo "Build Mosquitto on Centos"
echo "=========================================="

sleep 1
echo "Step 1. Install cmake openssl-devel packages"
sudo yum install cmake openssl-devel -y

sleep 1
echo "Step 2. wget mosquitto.tar & unarchive" 
cd ~
wget http://mosquitto.org/files/source/mosquitto-1.4.7.tar.gz
sudo tar -xzvf mosquitto-1.4.7.tar.gz
cd ~/mosquitto-1.4.7


echo "Step 3. wget c-ares & unarchive" 
sleep 1
cd ~/mosquitto-1.4.7
wget http://c-ares.haxx.se/download/c-ares-1.10.0.tar.gz
sudo tar xvf c-ares-1.10.0.tar.gz
cd c-ares-1.10.0
./configure
make
sudo make install


sleep 1
echo "Step 4. Install libuuid-devel package."
sudo yum install libuuid-devel -y


sleep 1
echo "Step 5. wget libwebsockets  & unarchive" 
cd ~/mosquitto-1.4.7
wget https://github.com/warmcat/libwebsockets/archive/v1.3-chrome37-firefox30.tar.gz
sudo tar zxvf v1.3-chrome37-firefox30.tar.gz
cd libwebsockets-1.3-chrome37-firefox30
mkdir build; cd build;
cmake .. -DLIB_SUFFIX=64
sudo make install

sleep 1
echo "Step 6. make install"
cd ~/mosquitto-1.4.7
make
sudo make install


sleep 1
echo "Step 7. /etc/mosquitto/mosquitto.conf "
sudo mv /etc/mosquitto/mosquitto.conf.example /etc/mosquitto/mosquitto.conf

sleep 1
echo "Step 8. user, groupadd mosquitto"

sudo groupadd mosquitto
sudo useradd -g mosuqitto mosquiotto

sleep 1
echo "Step 9. mosquitto_pub & sub configure"

sudo cat > /etc/ld.so.conf << EOF
include ld.so.conf.d/*.conf
include /usr/local/lib
/usr/lib
/usr/local/lib
EOF

sudo /sbin/ldconfig
sudo ln -s /usr/local/lib/libmosquitto.so.1 /usr/lib/libmosquitto.so.1

sleep 1
echo "Complete!!!"
