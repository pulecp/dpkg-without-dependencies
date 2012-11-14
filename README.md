dpkg-without-dependencies
=========================

This ruby script removes dependencies from list of all installed packages. When you image package dependencies as tree, this script return leaves of this tree.


## Preparing

Before you run ruby script, you have to make file with packages. One package at line. You can use this command:

    dpkg -l | sed -n '6,$s/....\([^ ]*\).*/\1/p' > filename

Ruby script using package `apt-rdepends`

    apt-get install apt-rdepends

## Run ruby script

Script writes in file `filename_out` packages which are not dependent on others. File `filename_in` contains packages you want to solve line by line.

    ruby dpkg-without-dependencies.rb filename_in filename_out

### Bugs

This script using `apt-rdepends` which contains bugs. It have problems with virtual packages and a few more.
For more information check manual page or http://manpages.ubuntu.com/manpages/natty/en/man8/apt-rdepends.8.html
