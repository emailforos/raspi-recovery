#!/bin/sh
echo "\n*** Instalando docker ***\n"
sudo apt-get install -y software-properties-common apparmor-utils apt-transport-https avahi-daemon ca-certificates curl dbus jq network-manager socat
sudo curl -fsSL get.docker.com | sh
echo "\n*** Instalando docker-compose ***\n"
sudo apt-get update sudo apt-get install -y docker-compose
sudo groupadd docker
sudo usermod -aG docker ${USER}
docker-compose --version
echo "\n*** Creando carpetas para los contenedores ***\n"
sh ./dir.sh
sudo chown pi:pi -R *
echo "\n*** Creando ficheros .yml docker-compose ***\n"
wget -O $HOME/docker/docker-compose.yml https://raw.githubusercontent.com/emailforos/contenedores/main/docker-compose.yml
echo "\n*** Creando ficheros para filebrowser ***\n"
wget -O $HOME/docker/filebrowser/.filebrowser.json https://raw.githubusercontent.com/filebrowser/filebrowser/master/docker/root/defaults/settings.json
touch $HOME/docker/filebrowser/filebrowser.db
echo "\n*** Instalando NUT ***\n"
sudo apt autoclean -y && sudo apt autoremove -y && sudo apt purge -y && sudo apt update && sudo apt upgrade -y
sudo apt install nut -y
cd $HOME/docker/nut
git init
cd $HOME/docker
git clone https://github.com/emailforos/nut
sudo cp *.* /etc/nut
echo "\n*** Creando contenedores ***\n"
echo "\n*** Descargando imagenes nuevas ***\n" && docker-compose pull echo "\n*** Instalando imagenes nuevas ***\n" && docker-compose up -d echo "\n*** Borrando imagenes viejas ***\n" && docker image prune -a -f
echo "\n*** Instalando samba ***\n"
sudo apt update && sudo apt install samba samba-common -y
sudo wget -O /etc/samba/smb.conf https://raw.githubusercontent.com/emailforos/raspi-recovery/main/samba/smb.conf
sudo smbpasswd -a pi
sudo service smbd restart
echo "\n*** FIN - ¡REINICIA LA RASPI! ***\n" 
