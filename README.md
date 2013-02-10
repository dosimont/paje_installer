Paje-Installer
==============

Script which allows to install Pajé visualization tool and its dependencies (GNUstep and necessary libraries)


###Step 1) Install necessary libraries

- If your OS is __Fedora__:

        $ ./paje_installer.sh -fedoralibs

- If your OS is __Ubuntu__:

        $ ./paje_installer.sh -ubuntulibs

###Step 2) Download and install GNUstep

    $ ./paje_installer.sh -gnustep

###Step 3) Download and install Pajé

    $ ./paje_installer.sh -paje

###To remove GNUstep and Pajé (care if you have other programs running with GNUstep, they will be removed too)

    $ ./paje_installer.sh -uninstall

###To recompile and reinstall Pajé

    $ ./paje_installer.sh -remake

###Environment Settings : 

add to your __.bash_profile__ the following line:

    $ source /usr/GNUstep/System/Library/Makefiles/GNUstep.sh


