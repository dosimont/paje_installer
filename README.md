Paje-Installer
==============

Script which allows to install Pajé visualization tool and its dependencies (GNUstep and necessary libraries)


Step 1) Install necessary libraries
===================================

- If your OS is Fedora:

$ ./paje-installer.sh -fedoralibs

- If your OS is Ubuntu:

$ ./paje-installer.sh -ubuntulibs

Step 2) Download and install GNUstep
====================================

$ ./paje-installer.sh -gnustep

Step 3) Download and install Pajé
=================================

$ ./paje-installer.sh -paje



To remove GNUstep and Pajé (care if you have other programs running with GNUstep, they will be removed too)
===========================================================================================================

$ ./paje-installer.sh -uninstall

To recompile and reinstall Pajé
===============================

$ ./paje-installer.sh -remake
