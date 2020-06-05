read -p "Have you already copied/uploaded the internal docker repo certificate files to your home directory? " -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
  sudo mkdir /usr/share/ca-certificates/extra; 
  sudo cp cert_root_devops_hq1.cer /usr/share/ca-certificates/extra/cert_root_devops_hq1.cer; 
  sudo dpkg-reconfigure ca-certificates; 
  sudo update-ca-certificates; 
  sudo mkdir -p /etc/docker/certs.d/devops.hq1.nakisa.net; 
  sudo cp NEW-devops.hq1.nakisa.net.crt /etc/docker/certs.d/devops.hq1.nakisa.net/ca.crt; 
  sudo docker login -u docker devops.hq1.nakisa.net;
fi
