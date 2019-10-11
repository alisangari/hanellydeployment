read -p "Have you already copied/uploaded the certificate files to your home directory? " -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
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

#	sudo mkdir /nakisa
	sudo mkdir /nakisa/app
	sudo mkdir /nakisa/app-hanelly
	sudo mkdir /nakisa/app-hanelly/apache-conf 
	sudo mkdir /nakisa/app-hanelly/apache-ssl 
	sudo mkdir /nakisa/app-hanelly/hanelly-data
	sudo mkdir /nakisa/app-hanelly/hanelly-data/data-batches/
	sudo mkdir /nakisa/app-hanelly/hanelly-data/upgradability/

	sudo mkdir /nakisa/app-hanelly/es-data
	sudo mkdir /nakisa/app-hanelly/es-dump
	sudo mkdir /nakisa/app-hanelly/es-logs
	sudo chown -R 101:102 /nakisa/app-hanelly/es-data /nakisa/app-hanelly/es-dump /nakisa/app-hanelly/es-logs
	sudo chmod -R 777 /nakisa/app-hanelly/es-data /nakisa/app-hanelly/es-dump /nakisa/app-hanelly/es-logs

	sudo touch /nakisa/app-hanelly/hanelly-data/serial
	sudo touch /nakisa/app-hanelly/hanelly-data/data-batches/batches.properties

	sudo sh -c "wget -O - https://raw.githubusercontent.com/alisangari/hanellydeployment/master/conf.properties > /nakisa/app-hanelly/hanelly-data/conf.properties"
	sudo sh -c "wget -O - https://raw.githubusercontent.com/alisangari/hanellydeployment/master/nakisa.jaas.config > /nakisa/app-hanelly/hanelly-data/nakisa.jaas.config"
	sudo sh -c "wget -O - https://raw.githubusercontent.com/alisangari/hanellydeployment/master/hanelly-ssl.conf > /nakisa/app-hanelly/apache-conf/hanelly-ssl.conf"
	sudo sh -c "wget -O - https://raw.githubusercontent.com/alisangari/hanellydeployment/master/docker-compose-hanelly-3-5.yml >  /nakisa/app/docker-compose-hanelly-3-5.yml"
	sudo sh -c "wget -O - https://raw.githubusercontent.com/alisangari/hanellydeployment/master/nakisa.config.switches-adv.xml >  /nakisa/app-hanelly/hanelly-data/upgradability/nakisa.config.switches-adv.xml"

	echo ********** Copying certificate files from home directory **********
	sudo cp ~/cert.crt ~/cert.key /nakisa/app-hanelly/apache-ssl/

	echo ********** pulling the docker containers and starting the containers **********
	echo Enter docekrhub username and password
	echo Username: 
	read username
	echo Password:
	read -s password

	sudo docker login -u $username -p $password
	sudo docker-compose -f /nakisa/app/docker-compose-hanelly-3-5.yml pull
#	sudo docker-compose -f /nakisa/app/docker-compose-hanelly.yml up -d
#       sudo https://<server>/hanelly/app/services/ConfigSwitchRestoreService/restoreConfigSwitchBackup?filename=nakisa.config.switches-adv.json&j_token=0021121f6d0a4bdbbf9c8488da731d38a4544b00a2074d8284755b24ed2074bd
fi
