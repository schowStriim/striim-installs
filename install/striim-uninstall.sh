echo "Which operating system are you using? (amazon, centos, redhat, ubuntu or debian)"
read os

#Delete Java
sudo rm -rf /usr/lib/jvm/
sudo rm -rf /usr/bin/java

if [ $os == 'ubuntu' ] || [ $os == 'debian' ];
then
	sudo dpkg -r striim-node
	sudo dpkg -r striim-dbms
		
elif [ $os == 'centos' ] || [ $os == 'redhat' ] || [ $os == 'amazon' ];
then
	sudo rpm -e striim-node
	sudo rpm -e striim-dbms
else
	echo "${RED} Wrong selection. Please enter either amazon, debian, ubuntu, centos or redhat. ${NC} "
	exit 1
fi

#Delete Striim directory
sudo rm -rf /opt/striim/
