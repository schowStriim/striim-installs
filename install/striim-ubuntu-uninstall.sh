# Uninstall Java (1.8)
rm -rf /usr/lib/jvm/
rm -rf /usr/bin/java

# Uninstall Striim
sudo dpkg -r striim-node
sudo dpkg -r striim-dbms
rm -rf /opt/striim/
