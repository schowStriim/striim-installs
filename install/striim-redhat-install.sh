################################################################################################
# DESCRIPTION: (RedHat) This bash script does the following:                                   # 
# 1) Installs Java JDK (1.8).                                                                  #
# 2) Installs Striim (4.1.0.1).                                                                # 
# 3) Sets up Striim configuration (startup.properties and runs sksConfig file).                #
# 4) Enables/Starts Striim dbms and node.                                                      #
#                                                                                              # 
# PRE-REQUISITE:                                                                               #
# 1) This script is only for RedHat, CentOS or Amazon Linux 2 operating system.                #
# 2) Need to export your striim licence (example shown below) as environment variables         # 
#    before executing this script.                                                             # 
#                                                                                              #
# For example:                                                                                 #
# export licence_key=<value>                                                                   #
# export product_key=<value>                                                                   #
# export cluster_name=<value>                                                                  #
# export company_name=<value>                                                                  #
#################################################################################################
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
NC=$'\e[0m'

startup_config=/opt/striim/conf/startUp.properties

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
fi

# Install Java JDK (1.8)
echo "${GREEN} Install Java JDK 1.8 ${NC}"
curl -0 -L https://striim-downloads.s3.us-west-1.amazonaws.com/jdk-8u341-linux-x64.tar.gz --output jdk-8u341-linux-x64.tar.gz
mkdir -p /usr/lib/jvm
tar zxvf jdk-8u341-linux-x64.tar.gz -C /usr/lib/jvm
update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0_341/bin/java" 1
update-alternatives --set java /usr/lib/jvm/jdk1.8.0_341/bin/java

# Install Striim
echo "${GREEN} Install Striim Version 4.1.0.1 ${NC}"
curl -L https://striim-downloads.striim.com/Releases/4.1.0.1/striim-dbms-4.1.0.1-Linux.rpm --output striim-dbms-4.1.0.1-Linux.rpm
curl -L https://striim-downloads.striim.com/Releases/4.1.0.1/striim-node-4.1.0.1-Linux.rpm --output striim-node-4.1.0.1-Linux.rpm
sudo rpm -ivh striim-dbms-4.1.0.1-Linux.rpm
sudo rpm -ivh striim-node-4.1.0.1-Linux.rpm

# Setup Striim's credentials
if [ -d "/opt/striim/bin" ]
then
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
    sed -i 's/# MEM_MAX=4096m/'"MEM_MAX=${mb_mem_max}m"'/' $startup_config
    sed -i 's/# MaxHeapUsage=95/'"MaxHeapUsage=95"'/' $startup_config

    # Start and enable Striim dbms and node

    sudo systemctl enable striim-dbms
    sudo systemctl start striim-dbms
    sudo systemctl status striim-dbms
    sleep 5
    sudo systemctl enable striim-node
    sudo systemctl start striim-node
    sudo systemctl status striim-node
    echo "${GREEN} Succesfully started Striim node and dbms ${NC}"

    #Verify instance is running
    sudo tail -F /opt/striim/logs/striim-node.log
else
      echo "${RED} Striim installation failed. Please check logs. ${NC} " 1>&2
      exit 1
fi

