#!/bin/bash
echo "\n*** INSTALANDO DOCKER ***\n"
# https://docs.docker.com/engine/install/debian/#install-using-the-repository
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl
echo "\n*** Instalando repositorio ***\n"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
echo "\n*** Instalando paquetes ***\n"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker ${USER}
docker compose version
echo "\n*** Creando carpetas para los contenedores ***\n"
cd $HOME
wget -O $HOME/dir.sh https://raw.githubusercontent.com/emailforos/raspi-recovery/main/dir.sh
bash dir.sh
sudo chown ${USER}:${USER} -R *
echo "\n*** Creando ficheros .yml docker-compose ***\n"
cd $HOME/docker/compose/domotica
wget https://raw.githubusercontent.com/emailforos/contenedores/main/compose/domotica/docker-compose.yml
wget https://raw.githubusercontent.com/emailforos/contenedores/main/compose/domotica/env
cd $HOME/docker/compose/sistema
wget https://raw.githubusercontent.com/emailforos/contenedores/main/compose/sistema/docker-compose.yml
wget .env https://raw.githubusercontent.com/emailforos/contenedores/main/compose/sistema/env
cd $HOME/docker/compose/media
wget https://raw.githubusercontent.com/emailforos/contenedores/main/compose/media/docker-compose.yml
wget .env https://raw.githubusercontent.com/emailforos/contenedores/main/compose/media/env
cd $HOME/docker/compose/nube
wget https://raw.githubusercontent.com/emailforos/contenedores/main/compose/nube/docker-compose.yml
wget .env https://raw.githubusercontent.com/emailforos/contenedores/main/compose/nube/docker-compose.yml
echo "\n*** Creando ficheros para filebrowser ***\n"
wget -O $HOME/docker/filebrowser/.filebrowser.json https://raw.githubusercontent.com/filebrowser/filebrowser/master/docker/root/defaults/settings.json
touch $HOME/docker/filebrowser/filebrowser.db
# echo "\n*** Instalando NUT ***\n"
# sudo apt autoclean -y && sudo apt autoremove -y && sudo apt purge -y && sudo apt update && sudo apt upgrade -y
# sudo apt install nut -y
# cd $HOME/docker/nut
# git init
# cd $HOME/docker
# git clone https://github.com/emailforos/nut
# sudo cp *.* /etc/nut
echo "\n*** Creando contenedores ***\n"
echo "\n*** Descargando imagenes nuevas ***\n" 
cd $HOME/docker/compose/sistema
docker compose pull 
cd $HOME/docker/compose/domotica
docker compose pull 
cd $HOME/docker/compose/media
docker compose pull 
cd $HOME/docker/compose/nube
docker compose pull 
echo "\n*** Instalando imagenes nuevas ***\n"
cd $HOME/docker/compose/sistema
docker compose up -d
cd $HOME/docker/compose/domotica
docker compose up -d
cd $HOME/docker/compose/media
docker compose up -d
cd $HOME/docker/compose/nube
docker compose up -d
echo "\n*** Borrando imagenes viejas ***\n" 
docker image prune -a -f
echo "\n*** Instalando samba ***\n"
sudo apt update && sudo apt install samba samba-common -y
sudo wget -O /etc/samba/smb.conf https://raw.githubusercontent.com/emailforos/raspi-recovery/main/samba/smb.conf
sudo smbpasswd -a ${USER}
sudo service smbd restart
echo "\n*** FIN - ¡REINICIA LA RASPI! ***\n" 
