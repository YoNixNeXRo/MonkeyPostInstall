# MonkeyPostInstall
Post install shell script for vm (mostly), works better with debian


**What does it do ?**

- update 
- upgrade
- remove useless packages
- install usefull packages
- creat ssh key for root
- creat ssh key for user
- add a sudo user ape with password P@ssword
- setup vim
- setup network (need to uncomment lines in code)
- setup issue.net
- setup figlet
- setup time zone to Europe/Paris
- setup usefull .bashrc
- disable recovery mod on grub
- setup grub password
- change video resolution
- change grub timeout
- install cheat tool, github : https://github.com/cheat/cheat
- creat chroot for user
- install and setup dropbear to ssh at bootloading (need to put your dropbear key)
- install and setup nginx
- install and setup mariadb
- install php
- install bookstack because why not
- make it pretty
- reboot

**Why is it called MonkeyPostInstall ?**

Because the code works but the indentation is null. And there is no class, everything was written on the fly, like a monkey.
