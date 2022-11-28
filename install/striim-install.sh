#!/bin/bash
################################################################################################
# DESCRIPTION: This bash script does the following:                                   	       #	 
# 1) Installs Java JDK (1.8).                                                                  #
# 2) Installs Striim (4.1.0.1).                                                                # 
# 3) Sets up Striim configuration (startup.properties and runs sksConfig file).                #
# 4) Creates a single or multiple Initial Load application(s). (Optional)		       #
# 5) Enables/Starts Striim dbms and node.                                                      #
#                                                                                              # 
# PRE-REQUISITE:                                                                               #
# 1) This script is only for Ubuntu, CentOS, Amazon Linux, Debian and RedHat operating system. #
# 2) Need to export your license information (example shown below) as environment variables    # 
#    before executing this script.                                                             # 
#                                                                                              #
# For example:                                                                                 #
# export licence_key=<value>                                                                   #
# export product_key=<value>                                                                   #
# export cluster_name=<value>                                                                  #
# export company_name=<value>                                                                  #
# export total_memory=<value>								       #
################################################################################################
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
NC=$'\e[0m'

# Check to see if environment variables are set to configure startup.properties file
if [[ -z "$company_name" ]]; then
    echo "${RED} Must provide company_name in environment ${NC} " 1>&2
    exit 1
elif [[ -z "$cluster_name" ]]; then
    echo "${RED} Must provide cluster_name in environment ${NC} " 1>&2
    exit 1
elif [[ -z "$licence_key" ]]; then
    echo "${RED} Must provide licence_key in environment ${NC} " 1>&2
    exit 1
elif [[ -z "$product_key" ]]; then
    echo "${RED} Must provide product_key in environment ${NC} " 1>&2
    exit 1
elif [[ -z "$total_memory" ]]; then
    echo "${RED} Must provide total_memory in environment ${NC} " 1>&2
    exit 1
fi

startup_config=/opt/striim/conf/startUp.properties
echo "######################"
echo "# Welcome to Striim! #"
echo "######################"

echo "Please answer the following to get started with the installation process."
echo "Which operating system are you using? (amazon, centos, redhat, ubuntu or debian)"
read os

if [ $os == 'ubuntu' ] || [ $os == 'debian' ];
then	
	# Install Striim
	echo "${GREEN} Install Striim Version 4.1.0.2 ${NC}"
	curl -L https://striim-downloads.striim.com/Releases/4.1.0.2/striim-dbms-4.1.0.2-Linux.deb --output striim-dbms-4.1.0.2-Linux.deb
	curl -L https://striim-downloads.striim.com/Releases/4.1.0.2/striim-node-4.1.0.2-Linux.deb --output striim-node-4.1.0.2-Linux.deb 
	sudo dpkg -i striim-dbms-4.1.0.2-Linux.deb
	sudo dpkg -i striim-node-4.1.0.2-Linux.deb
	sudo apt-get install bc -y
elif [ $os == 'centos' ] || [ $os == 'redhat' ] || [ $os == 'amazon' ];
then
	echo "${GREEN} Install Striim Version 4.1.0.2 ${NC}"
	curl -L https://striim-downloads.striim.com/Releases/4.1.0.2/striim-dbms-4.1.0.2-Linux.rpm --output striim-dbms-4.1.0.2-Linux.rpm
	curl -L https://striim-downloads.striim.com/Releases/4.1.0.2/striim-node-4.1.0.2-Linux.rpm --output striim-node-4.1.0.2-Linux.rpm
	sudo rpm -ivh striim-dbms-4.1.0.2-Linux.rpm
	sudo yum install bc -y
	sudo rpm -ivh striim-node-4.1.0.2-Linux.rpm
else
	echo "${RED} Wrong selection. Please enter either amazon, debian, ubuntu, centos or redhat. ${NC} "
	exit 1
fi

# Install Java JDK (1.8)
echo "${GREEN} Install Java JDK 1.8 ${NC}"
curl -0 -L https://striim-downloads.s3.us-west-1.amazonaws.com/jdk-8u341-linux-x64.tar.gz --output jdk-8u341-linux-x64.tar.gz
mkdir -p /usr/lib/jvm
tar zxvf jdk-8u341-linux-x64.tar.gz -C /usr/lib/jvm
update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0_341/bin/java" 1
update-alternatives --set java /usr/lib/jvm/jdk1.8.0_341/bin/java


if [ -d "/opt/striim/bin" ]
then
    # Setup Striim's credentials
    echo "${GREEN} Setup Striim Credentials ${NC}"
    sudo su - striim /opt/striim/bin/sksConfig.sh

    sed -i 's/WAClusterName=/'"WAClusterName=$cluster_name"'/' $startup_config
    sed -i 's/CompanyName=/'"CompanyName=$company_name"'/' $startup_config
    sed -i 's/# ProductKey=/'"ProductKey=$product_key"'/' $startup_config
    sed -i 's/# LicenceKey=/'"LicenceKey=$licence_key"'/' $startup_config

    echo "${GREEN} Successfully updated startup.properties file ${NC}"
    
    # Allocate memory to Striim server

    gb_mem_max=$(echo "scale=1; 70/100 * $total_memory " | bc -l | xargs printf "%.0f")
    mb_mem_max=$(echo "scale=1; 1024 * $gb_mem_max " | bc -l )
    sed -i 's/# MEM_MIN=1024m/'"MEM_MIN=1024m"'/' $startup_config
    sed -i 's/# MEM_MAX=4096m/'"MEM_MAX=${mb_mem_max}m"'/' $startup_config
    sed -i 's/# MaxHeapUsage=95/'"MaxHeapUsage=95"'/' $startup_config

   
    # Start and enable Striim dbms and node

    sudo systemctl enable striim-dbms
    sudo systemctl start striim-dbms
    sleep 5
    sudo systemctl enable striim-node
    sudo systemctl start striim-node
    echo "${GREEN} Succesfully started Striim node and dbms ${NC}"
    
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    create_apps_filepath="$SCRIPT_DIR"/create_initial_load_applications.sh
    
    if [ -f "$create_apps_filepath" ]; then
       $create_apps_filepath
    fi
 
    #Verify instance is running
    sudo tail -F /opt/striim/logs/striim/striim-node.log
else
      echo "${RED} Striim installation failed. Please check logs. ${NC} " 1>&2
      exit 1
fi

