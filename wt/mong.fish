#!/usr/bin/env fish 
echo ""
echo "Install mongosh - mongodb cli"
echo ""
echo " Commands to be run"
echo "--------------------"
echo ""
echo (set_color magenta)"wget https://downloads.mongodb.com/compass/mongodb-mongosh_2.1.0_amd64.deb"
echo (set_color magenta)"sudo dpkg -i mongodb-mongosh_2.1.0_amd64.deb"
echo (set_color magenta)"mongosh --version"
echo (set_color white)""
wget https://downloads.mongodb.com/compass/mongodb-mongosh_2.1.0_amd64.deb
sudo dpkg -i mongodb-mongosh_2.1.0_amd64.deb
mongosh --version
rm mongodb-mongosh_2.1.0_amd64.deb
echo "Done Lick her pussy!"
echo ""