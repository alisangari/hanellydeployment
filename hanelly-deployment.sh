echo ********** Installing HAnelly **********
echo Enter password for sudo command
sudo apt-get update
grep -q "vm.max_map_count" /etc/sysctl.conf
if [ $? -ne 0 ]
then
    echo 'vm.max_map_count=262144' | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
fi

echo ********** Installing docker and docker-compose **********
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get install docker-ce -y
sudo curl -o /usr/local/bin/docker-compose -OL https://github.com/docker/compose/releases/download/1.16.1/docker-compose-Linux-x86_64 && sudo chmod +x /usr/local/bin/docker-compose

echo Enter password for sudo command
sudo su
mkdir /nakisa
mkdir /nakisa/app
mkdir /nakisa/app-hanelly
mkdir /nakisa/app-hanelly/apache-conf 
mkdir /nakisa/app-hanelly/apache-ssl 
mkdir /nakisa/app-hanelly/hanelly-data
mkdir /nakisa/app-hanelly/hanelly-data/data-batches/

touch /nakisa/app-hanelly/hanelly-data/serial
touch /nakisa/app-hanelly/hanelly-data/data-batches/batches.properties

wget -O - http://gitlab.hq1.nakisa.net/devops/dcompose-vagrant/raw/master/files/tomcat_files/conf.properties > /nakisa/app-hanelly/hanelly-data/conf.properties
wget -O - http://gitlab.hq1.nakisa.net/devops/dcompose-vagrant/raw/master/files/tomcat_files/nakisa.jaas.config > /nakisa/app-hanelly/hanelly-data/nakisa.jaas.config
wget -O - http://gitlab.hq1.nakisa.net/devops/dcompose-vagrant/raw/master/files/apache-conf/hanelly-ssl.conf > /nakisa/app-hanelly/apache-conf/hanelly-ssl.conf
wget -O - http://gitlab.hq1.nakisa.net/devops/dcompose-vagrant/raw/master/files/yml-templates/docker-compose-hanelly.yml.template >  /nakisa/app/docker-compose-hanelly.yml
exit

echo ********** Copying certificate files from home directory **********
echo Enter password for sudo command
sudo cp ~/cert.crt ~/cert.key /nakisa/app-hanelly/apache-ssl/

echo Enter docekrhub username and password
echo Username: 
read username
echo Password:
read password

sudo docker login -u $username -p $password
sudo docker-compose -f /nakisa/app/docker-compose-hanelly.yml pull
sudo docker-compose -f /nakisa/app/docker-compose-hanelly.yml up -d
