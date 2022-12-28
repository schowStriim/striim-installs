# Striim Installation
## Steps to install and configure Striim and Java (1.8).

1) Connect to your VM and install Git by running this command:
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

7) After the script installs Java and Striim, it will show a prompt for you to set your KeyStore, sys and admin user password. 
    - Note: You will login to Striim console with the admin credentials you entered in this step.
   
8) Select '1' or 'Derby' when it asks you to enter the MDR Types.

9) After the script configures Striim node and database, it will show a prompt asking if you'd like to create your Initial Load TQL file.
    - If your answer is 'yes', you will have to provide the following:
        - Enter source JDBC URL: `jdbc:oracle:thin:[<user>/<password>]@<host>[:<port>]:<SID>` 
        - Enter schemas and tables to exclude: `<schema_1>;<schema_2>;<schema_3>`
        - Enter username: `<database_user>`
        - Enter password: `<password>`
        - Enter # IL applications: `1`
            - Note: We recommend entering a value of `1` for the initial PoC but if you'd like to increase the performance of the initial load, enter a  number greater than one and a Java script will calculate the size of your tables and split the applications accordingly. For more information, please contact the Striim team.
        - Enter the # Striim cores: `16`
            - Note: This value is used to parallelize the initial load and split the threads depending on the amount of applications you created.
        - Enter target JDBC URL: `jdbc:sqlserver://[serverName[\instanceName][:portNumber]][;property=value[;property=value]]`
        - Enter username: `<database_user>`
        - Enter password: `<password>`
            
10) Wait until you get an output message like the following:
Please go to http://10.1.2.3.4:9080 or https://10.1.2.3.4:9081 to administer, or use console

11) Grab your instance public IP and type the following to your browser: <public-ip>:9080

12) Once you authenticate to the Striim console, you can import the TQL file(s) you created on step #9 by navigating to Apps -> Create Apps -> Import TQL Files.

13) **(Only for MySQL Reader)** In order to use the MySQL Reader in Striim, the user will have to install the MySQL JDBC adapter and store it in /opt/striim/lib/ directory. Link: https://www.striim.com/docs/en/install-the-mysql-jdbc-driver-in-a-forwarding-agent.html

14) **(Only for MariaDB Reader)** In order to use the MariaDB Reader in Striim, the user will have to install the MariaDB JDBC adapter and store it in /opt/striim/lib/ directory. Link: https://www.striim.com/docs/en/install-the-mariadb-jdbc-driver-in-a-forwarding-agent.html

If you don't see striim console up and running in your browser, make sure your instance has port 9080 open and your network is configured correctly.
