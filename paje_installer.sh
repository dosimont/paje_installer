#!/bin/sh
gnustep=0
paje=0
renaissance=0
tupi=0
triva=0
uninstall=0
make=0
base=0
gui=0
back=0
remake=0
if [ $# = 0 ]
then
	gnustep=1
	paje=1
	renaissance=1
	tupi=1
	triva=1
	make=1
	base=1
	gui=1
	back=1
else
	for i in $*
	do
		case $i in
			"-gnustep" ) gnustep=1; make=1; base=1; gui=1; back=1;;
			"-paje" ) paje=1;;
			"-renaissance" ) renaissance=1;;
			"-tupi" ) tupi=1;;
			"-triva" ) triva=1;;
			"-uninstall" ) uninstall=1;;
			"-make" ) gnustep=1; make=1;;
			"-base" ) gnustep=1; base=1;;
			"-gui" ) gnustep=1; gui=1;;
			"-back" ) gnustep=1; back=1;;
			"-remake" ) remake=1;;
		esac
	done
fi
if [ $uninstall = 1 ]
then
	sudo rm -fr src
	sudo rm -fr /home/dosimont/GNUstep
        sudo rm -fr /usr/GNUstep
	exit 0
fi
if [ $remake = 1 ]
then
	. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
	export LANG=C
	cd src
	for dir in Paje renaissance tupi triva
	do
		cd $dir
		make -j8
		make install GNUSTEP_INSTALLATION_DOMAIN=USER
		cd ..
	done
	defaults write NSGlobalDomain GSBackend libgnustep-cairo
	exit 0
fi
sudo yum install libxml2-devel libxslt-devel openssl-devel libX11-devel libXext-devel libXt-devel libjpeg*devel libtiff-devel libpng-devel libffi-devel graphviz-devel libmatheval-devel gsl-devel cairo-devel libXfixes-devel libXcursor-devel libXmu-devel libXft-devel libicu-devel clang 
sudo yum groupinstall "Development Tools"
export CC=clang
mkdir src
cd src
if [ $gnustep = 1 ]
then
	if [ $make = 1 ]
	then
		#GNUstep-make, round 1
		svn checkout http://svn.gna.org/svn/gnustep/tools/make/trunk gnustep-make
		cd gnustep-make
		./configure --enable-debug-by-default --with-layout=gnustep
		make -j8
		sudo -E make install
		cd ..
		#Build the GNUstep runtime (libobjc2)
		svn checkout http://svn.gna.org/svn/gnustep/libs/libobjc2/trunk libobjc2
		cd libobjc2
		. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh 
		make -j8 debug=no
		sudo -E make strip=yes install
		cd ..
		#GNUstep-make, round 2
		cd gnustep-make
		./configure --enable-debug-by-default --enable-objc-nonfragile-abi --with-layout=gnustep
		make -j8
		sudo -E make install
		cd ..
	fi
	#Build GNUstep base, gui and back
	if [ $base = 1 ]
	then
		#gnustep-base
		svn checkout http://svn.gna.org/svn/gnustep/libs/base/trunk gnustep-base
		cd gnustep-base
		. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
		./configure
		make -j8
		sudo -E make install	
		cd ..
	fi
	if [ $gui = 1 ]
	then
		#gnustep-gui
		svn checkout http://svn.gna.org/svn/gnustep/libs/gui/trunk gnustep-gui
		cd gnustep-gui
		. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
		./configure
		make -j8
		sudo -E make install
		cd ..
	fi
	if [ $back = 1 ]
	then
		#gnustep-back
		svn checkout http://svn.gna.org/svn/gnustep/libs/back/trunk gnustep-back
		cd gnustep-back
		. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
		./configure --enable-graphics=cairo --with-name=cairo
	#	./configure --enable-graphics=art --with-name=art
		make -j8
		sudo -E make install
		cd ..
	fi
fi
if [ $paje = 1 ]
then
	. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
	git clone git://paje.git.sourceforge.net/gitroot/paje/paje Paje
	export LANG=C
	cd Paje
	git checkout 
	make -j8
	make install GNUSTEP_INSTALLATION_DOMAIN=USER
	defaults write NSGlobalDomain GSBackend libgnustep-cairo
	cd ..
fi
if [ $renaissance = 1 ]
then
	svn co http://svn.gna.org/svn/gnustep/libs/renaissance/trunk renaissance
	cd renaissance
	. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
	make -j8
	make install GNUSTEP_INSTALLATION_DOMAIN=USER
	cd ..
fi
if [ $tupi = 1 ]
then
	git clone https://github.com/schnorr/tupi.git	
	cd tupi
	. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
	make -j8
	make install GNUSTEP_INSTALLATION_DOMAIN=USER
	cd ..
fi
if [ $triva = 1 ]
then
	git clone https://github.com/schnorr/triva.git
	cd triva
	. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
	export LANG=C
	make -j8
	make install GNUSTEP_INSTALLATION_DOMAIN=USER
	cd ..
	defaults write NSGlobalDomain GSBackend libgnustep-cairo
fi
exit 0
