#############################
#                           #
#   update,remove,install   #
#                           #
#############################
apt update -y
apt upgrade -y

apt remove task-laptop telnet  -y



apt install -y mlocate rsync htop net-tools vim tmux screen zip pigz pixz iotop git psmisc git \
		tree lynx at lshw inxi figlet gdisk mc cifs-utils ntfs-3g sudo \
		sshfs apt-file openssl gnupg2 dnsutils fish gpm grc ncdu p7zip-full curl \
		parted 

apt autoremove -y
apt clean -y



#############################
#                           #
#   creat ssh key for root  #
#                           #
#############################


mkdir -v ~/.ssh
chmod -v 700 ~/.ssh

ssh-keygen -t ed25519 -f /root/.ssh/id_ed25519 -q -N ""




#############################
#                           #
#   creat ssh key for user  #
#                           #
#############################

user=$(grep bash /etc/passwd|tail -1| cut -d: -f1)

mkdir -v /home/$user/.ssh
chmod -v 700 /home/$user/.ssh
ssh-keygen -t ed25519 -f /home/$user/.ssh/id_ed25519 -q -N ""
chmod -v 700 /home/$user

#test
chown -R $user:$user /home/$user/.ssh



#############################
#                           #
#   creat monkey banana     #
#                           #
#############################

groupadd -g 10000 ape
useradd -s /bin/bash -u 10000 -g 10000 -m ape
chmod -v 700 /home/ape
echo -e "P@ssword\nP@ssword" | passwd ape
usermod -aG sudo ape

#if you want $user
#user=$(grep sh /etc/passwd|tail -1| cut -d: -f1)

mkdir -v /home/ape/.ssh
chmod -v 700 /home/ape/.ssh
ssh-keygen -t ed25519 -f /home/ape/.ssh/id_ed25519 -q -N ""
chown -R ape:ape /home/ape/.ssh

chmod -v 640 /etc/ssh/ssh_config
chmod -v 640 /etc/ssh/sshd_config



#############################
#                           #
#           vim             #
#                           #
#############################

ln -sfn /usr/bin/vim.basic  /etc/alternatives/editor



#############################
#                           #
#         some stuff        #
#                           #
#############################


echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config




######################################
#                                    #
#   network to uncomment and adapt   #
#                                    #
######################################

#sed -i 's/dhcp/static/' /etc/network/interfaces

#cat >> /etc/network/interfaces << EOF
#	address 192.168.1.190
#	netmask 255.255.255.0
#	gateway 192.168.1.254
#	dns-nameservers 1.1.1.1 9.9.9.9
#EOF


##change to 3 if you have another network card
#nic=$(ip link | grep -w 2:|cut -d: -f2)
#ifdown $nic
#ifup $nic


######################################
#                                    #
#   Monkey kingdome stuff banana     #
#                                    #
######################################

cat > /etc/issue.net << EOF
******************************
*                            *
*     Monkey kingdome        *
*                            *
******************************
EOF

cp /etc/issue.net /etc/motd

figlet APE-TOGETHER-STRONG > /etc/motd

service ssh restart


#############################
#                           #
#        timezone           #
#                           #
#############################


#set good time zone
timedatectl set-timezone Europe/Paris
#NTP
timedatectl set-ntp on 
#systemctl status systemd-timesyncd
systemctl restart systemd-timesyncd




#############################
#                           #
#      change hostname      #
#                           #
#############################

sed -i 's/debian/wiki/g' /etc/hostname
sed -i 's/debian/wiki banana.ape.local/g' /etc/hosts



#############################
#                           #
#           .bashrc         #
#                           #
#############################


cat >> /tmp/.bashrc << EOF
HISTOCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=100000
export PROMPT_COMMAND='history -a;history -n;history -w'
export PS1='\n\e[0;31m\[******************************\n[\t] \u@\h \w \$ \e[m'
alias ll='ls -lh'
alias la='ls -lha'
alias l='ls -CF'
alias em='emacs -nw'
alias dd='dd status=progress'
alias _='sudo'
alias _i='sudo -i'
alias please='sudo'
alias fucking='sudo'
alias df="df -hT --total -x devtmpfs -x tmpfs"
alias rm="rm -iv --preserve-root"
alias grep="grep --color=auto"
alias vi="vim"
alias ll="ls -l"
alias cp="cp -i"                          # confirm before overwriting something
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more='less'
alias chmod="chmod -v --preserve-root"
alias reboot="shutdown -r"
alias off="shutdown -h"
alias grep="grep --color"
alias more="less"
alias chown="chown -v --preserve-root"
alias chgrp="chgrp -v --preserve-root"
export CHEAT_CONFIG_PATH="/etc/cheat/conf_autre.yml"
EOF

mv /root/.bashrc /root/.bashrc_old
cp /tmp/.bashrc /root/.bashrc
chmod 770 /root/.bashrc

mv /home/ape/.bashrc /home/ape/.bashrc_old
cp /tmp/.bashrc /home/ape
chown ape /home/ape/.bashrc
chmod 770 /home/ape/.bashrc

cat /etc/bash.bashrc >> /home/$user/.bashrc
cat >> /home/$user/.bashrc << EOF
export CHEAT_CONFIG_PATH="/etc/cheat/conf_chroot.yml"
EOF
cat >> /home/ape/.bashrc << EOF
export PS1="\[\e[32m\][\[\e[m\]\[\e[31m\]\u\[\e[m\]\[\e[33m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]:\[\e[36m\]\w\[\e[m\]\[\e[32m\]]\[\e[m\]\[\e[32;47m\]\\$\[\e[m\] "
export CHEAT_CONFIG_PATH="/etc/cheat/conf_autre.yml"
EOF



#############################
#                           #
#   path for cheat cheat    #
#                           #
#############################


mkdir -vp /home/$user/here

#################################
#                               #
#   grub disable recovery mod   #
#                               #
#################################

cat >> /etc/default/grub << EOF
GRUB_DISABLE_RECOVERY="true"
GRUB_DISABLE_SUBMENU=y
EOF
update-grub



#############################
#                           #
#   grub setup password     #
#                           #
#############################


sed -i '$a set superusers="grub"' /etc/grub.d/40_custom
grub_mdp_hash=`echo -e "grub\ngrub" | grub-mkpasswd-pbkdf2 | grep grub | awk -F " " '{ print $7}'`

sed -i '$a password_pbkdf2 grub HASH' /etc/grub.d/40_custom
sed -i "/HASH/s/HASH/$grub_mdp_hash/" /etc/grub.d/40_custom


sed -i 's/--class os/--class os --unrestricted/g' /etc/grub.d/10_linux



#############################
#                           #
#   grub  video quality     #
#                           #
#############################

sed -i 's/quiet/vga=791/' /etc/default/grub
sed -i "/GRUB_GFXMODE/s/^#//" /etc/default/grub
sed -i "/GRUB_GFXMODE/s/640x480/1920x1080/" /etc/default/grub




#############################
#                           #
#   grub setup timeout      #
#                           #
#############################
sed -i 's/=5/=20/' /etc/default/grub
update-grub





##################################################
#                                                #
#                setup du hostname               #
#                                                #
##################################################

	old_hostname=`hostname`
	hostnamectl set-hostname banana.ape.local
	sed -i "s/$old_hostname/banana.ape.local		wiki/g" /etc/hosts
	sed -i "s/127.0.1.1/192.168.1.190/" /etc/hosts


cat "9.9.9.9" >> /etc/resolv.conf


##########################################################
#                                                        #
#                   Install cheat cheat                  #
#                                                        #
##########################################################

cheat_version="4.2.0"
	cheat_type="cheat-linux-amd64"
	apt install wget
	wget https://github.com/cheat/cheat/releases/download/$cheat_version/$cheat_type.gz
	gzip -d $cheat_type.gz 

	mv $cheat_type /usr/bin/cheat
	cp /usr/bin/cheat /home/$user/here/cheat

	chmod +x /home/$user/here/cheat
	chmod +x /usr/bin/cheat

	mkdir -pv /etc/cheat

	chmod -R 755 /etc/cheat

cd /tmp 
git clone https://github.com/cheat/cheatsheets
cp /tmp/cheatsheets/* /home/$user/here/cheat/cheatsheets/community
	cat >>  /etc/cheat/conf_chroot.yml << EOF
editor: vim
colorize: true
style: monokai
formatter: terminal16m
cheatpaths:
 - name: community
   path: /home/$user/here/cheat/cheatsheets/community
   tags: [ community ] 
   readonly: true
 - name: personal
   path: /home/$user/here/cheat/cheatsheets/personal
   tags: [ community ] 
   readonly: false 
EOF

cat >>  /etc/cheat/conf_autre.yml << EOF
editor: vim
colorize: true
style: monokai
formatter: terminal16m
cheatpaths:
 - name: community
   path: /home/CHROOT/home/$user/here/cheat/cheatsheets/community
   tags: [ community ] 
   readonly: true
 - name: personal
   path: /home/CHROOT/home/$user/here/cheat/cheatsheets/personal
   tags: [ community ] 
   readonly: false 
EOF



##################################################
#                                                #
#                setup  dropbear                 #
#                                                #
##################################################

#cle publique a rajouter dans .ssh

	apt install dropbear busybox -y 

	sed -i "s/BUSYBOX=auto/BUSYBOX=y/g" /etc/initramfs-tools/initramfs.conf
	echo "DROPBEAR=y" >> /etc/initramfs-tools/initramfs.conf
	echo "IP=192.168.1.190::192.168.1.254:255.255.255.0:`hostname`" >> /etc/initramfs-tools/initramfs.conf
	
	cd /etc/dropbear-initramfs/
	/usr/lib/dropbear/dropbearconvert dropbear openssh dropbear_rsa_host_key id_rsa
	dropbearkey -y -f dropbear_rsa_host_key | grep "^ssh-rsa " > id_rsa.pub

	
	echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6VwQImas30Q8j7MwqmUZudgITgjRq4Rvt0xNmGjgBFepGDLcaVFyRO3/SwA5prDR+zfyGNZCQuPeWAwj2PAk+URGc+ZEEm3km+VdXIL9UWwIcYqze/11iOjCfsUoUhROJ1zthHMZfmHcg+gKFeJvm4+wi3HbqxiHZbMyoOpsEj45PUuDmYZ3WFV8stVwfeUg2W26ZuT/2aRnydLgxvhsOw7dZIZOAnpIaQ/zUsVQA/yHaDO9flO1D5q3W8/e6eXH/PLxqHgEs/kGTlIAgUeD3nQ+zfUzHbz30r5IstfMFBgTp8Mw15+Jbz6eM3S0nTCt1N31+uaACel1Q/JfwVoGRC9W6kilpeKVlpxLgCqpw/wMt3gmuxCjvDvHiTlR9Ks5+4ASUQKgZo3prUDhxLaoHzBT8vA1oK8SHkHXKWa6Mwp/SOpLuVTN3V28sXWr4R8SODMPs+t+IadIyjfO+rtimLy1ysMJtxweFgfl02TdscL6FvzbvoLxbJW7B3urQa5E= yonix_nexro@pavillon">> /etc/dropbear-initramfs/authorized_keys	
	
	echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8m/yZjlAlu7A7RrEhU5RWBqIt75mr2xecq3564/gzy davy@XEON" >> /etc/dropbear-initramfs/authorized_keys

	cd 
	sed -i "s/NO_START=1/NO_START=0/g" /etc/default/dropbear
	echo "DROPBEAR_OPTIONS=\"-p 21\"" >> /etc/dropbear-initramfs/config
       	update-initramfs -u 
	systemctl disable dropbear

	
	
##################################################
#                                                #
#                chroot user                     #
#                                                #
##################################################

mkdir /home/CHROOT
cd /home/CHROOT
rsync -Ra /usr/bin/ /home/CHROOT
rsync -Ra /usr/lib64/ /home/CHROOT
rsync -Ra /usr/lib/ /home/CHROOT

ln -s usr/bin/ bin
ln -s usr/lib lib
ln -s usr/lib64 lib64

rsync -Ra /home/$user/ /home/CHROOT/
rsync -Ra /dev/null /home/CHROOT/
rsync -Ra /dev/zero /home/CHROOT/


cd dev/
ln -s /dev/stdin 
ln -s /dev/stdout
ln -s /dev/sterr
rsync -Ra /dev/tty* /home/CHROOT/
rsync -Ra /etc/passwd /home/CHROOT/
rsync -Ra /etc/cheat/conf_chroot.yml  /home/CHROOT/

rsync -Ra /usr/sbin/cryptsetup /home/CHROOT/
rsync -Ra /usr/bin/mount /home/CHROOT/


touch /home/CHROOT/home/$user/.profile
cat >> /home/CHROOT/home/$user/.profile << EOF
# ~/.profile: executed by Bourne-compatible login shells.
if [ "$BASH" ]; then
  if [ -f /home/$user/.bashrc ]; then
    . ~/.bashrc
  fi
fi
mesg n || true
EOF

chmod 755 -R /home/CHROOT/


#############################
#                           #
#       change.profile      #
#                           #
#############################

cat >> /etc/ssh/sshd_config << EOF
Match User $user
        ChrootDirectory /home/CHROOT
  
EOF
systemctl restart ssh



##################################################
#                                                #
#                install nginx                   #
#                                                #
##################################################

apt install nginx -y

systemctl stop nginx.service
systemctl start nginx.service
systemctl enable nginx.service



##################################################
#                                                #
#                install mariadb                 #
#                                                #
##################################################

apt install -y mariadb-server mariadb-client
DB_PASS="password"

systemctl stop mariadb.service
systemctl start mariadb.service
systemctl enable mariadb.service

echo -e "Y\n$DB_PASS\n$DB_PASS\nY\nY\nY\nY" | mysql_secure_installation
mysql -u root --execute="CREATE DATABASE bookstack;"
mysql -u root --execute="CREATE USER 'bookstack'@'localhost' IDENTIFIED BY '$DB_PASS';"
mysql -u root --execute="GRANT ALL ON bookstack.* TO 'bookstack'@'localhost';FLUSH PRIVILEGES;"



##################################################
#                                                #
#                install php                     #
#                                                #
##################################################

apt install php$version-fpm php$version-mbstring php$version-curl php$version-mysql php$version-gd php$version-xml php-tokenizer -y



##################################################
#                                                #
#                install bookstack               #
#                                                #
##################################################

apt install composer -y

cd /var/www

git clone https://github.com/BookStackApp/BookStack.git --branch release --single-branch
cd BookStack
composer install --no-dev
cp .env.example .env
sed -i.bak "s@APP_URL=.*\$@APP_URL=http://$DOMAIN@" .env
sed -i.bak 's/DB_DATABASE=.*$/DB_DATABASE=bookstack/' .env
sed -i.bak 's/DB_USERNAME=.*$/DB_USERNAME=bookstack/' .env
sed -i.bak "s/DB_PASSWORD=.*\$/DB_PASSWORD=$DB_PASS/" .env
php artisan key:generate --no-interaction --force
echo -e "Y\n" | php artisan migrate 

	
cat >> /etc/nginx/sites-available/bookstack.conf << EOF
server { 
	listen 80;
	listen [::]:80;
	server_name wiki.esgi.local;
	root /var/www/BookStack/public;
	index index.php index.html;
	location / {
		try_files \$uri \$uri/ /index.php?\$query_string;
	}
	location ~ \.php$ { 
		fastcgi_index index.php;
		try_files \$uri =404;
		include fastcgi_params; 
		fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
		fastcgi_pass unix:/run/php/php7.3-fpm.sock;
	}
}
EOF
#mkdir -vp /etc/nginx/sites-available/bookstack
ln -s /etc/nginx/sites-available/bookstack.conf /etc/nginx/sites-enabled/

chown -R www-data:www-data /var/www/BookStack/

systemctl stop nginx.service
systemctl start nginx.service
systemctl enable nginx.service
# ou nginx -s reload


#############################
#                           #
#           reboot          #
#                           #
#############################

reboot
