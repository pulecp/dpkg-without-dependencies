dpkg-without-dependencies
=========================

This ruby script removes dependencies from list of all installed packages.


### STILL IN PROGRESS !!!



## Preparing

Before you run ruby script, you have to make file with packages. One package at line. You can use this command:

    dpkg -l | sed -n '6,$s/....\([^ ]*\).*/\1/p' > list_of_packages.txt  

