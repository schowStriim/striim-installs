# Uninstall Java (1.8)
rm -rf /usr/lib/jvm/
rm -rf /usr/bin/java

# Uninstall Striim
sudo rpm -e striim-node
sudo rpm -e striim-dbms
rm -rf /opt/striim/
