# Striim Installation
## Steps to install and configure Striim (4.1.0.1) and Java (1.8).

1) Logging to your VM and install Git in your Striim VM by running this command:
    - CentOS, Amazon Linux 2, and RedHat: 
        - `sudo yum update -y`
        - `sudo yum install git -y`
    - Ubuntu, and Debian: 
        - `sudo apt-get update -y`
        - `sudo apt-get install git-all -y`

2) Change to root user by running this command: `sudo su -`

3) Export your license key, product key, company name, total memory, and cluster name as environment variables to configure Striim.
    - For example:
      - `export company_name=Striim`
      - `export licence_key=12345676`
      - `export product_key=12345566`
      - `export total_memory=16`
      - `export cluster_name=Striim_cluster`
      
4) Clone this repository in the home directory: `git clone https://github.com/schowStriim/striim-installs.git`

5) Change directory to `striim-installs/install/`.

6) Execute striim-install.sh script: `./striim-install.sh`

7) After the script installs Java and Striim, it will show a prompt for you to enter your KeyStore, sys and admin user password. 
    - Note: You will login to Striim console with the admin credentials you entered in this step.
   
8) Select '1' or 'Derby' when it asks you to enter the MDR Types.

9) Wait until you get an output message like the following:
Please go to http://10.1.2.3.4:9080 or https://10.1.2.3.4:9081 to administer, or use console

10) Grab your instance public IP and type the following to your browser: <public-ip>:9080
    
If you don't see striim console up and running in your browser, make sure your instance has port 9080 open and your network is configured correctly.
