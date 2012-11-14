dpkg-without-dependencies
=========================

This ruby script removes dependencies from list of all installed packages. When you image package dependencies as tree, this script return leaves of this tree.


## Preparing

Before you run ruby script, you have to make file with packages. One package at line. You can use this command:

    dpkg -l | sed -n '6,$s/....\([^ ]*\).*/\1/p' > filename

## Run ruby script

Script writes in standard output packages which are not dependent on others. File <filename> contains packages line by line.

    ruby dpkg-without-dependencies.rb <filename>
