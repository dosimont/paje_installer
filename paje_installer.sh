#!/bin/sh

#  Paje-Installer - Script which allows to install Pajé visualization tool 
#  and its dependencies (GNUstep and necessary libraries)
#
#  Copyright (C) 2012 Damien Dosimont <damien.dosimont@gmail.com>
#
#  This program is free software; you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by the Free
#  Software Foundation; either version 3 of the License, or (at your option)
#  any later version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program.  If not, see <http://www.gnu.org/licenses/>.

dir="downloaded"

gnustep=0
paje=0
uninstall=0
make=0
base=0
gui=0
back=0
remake=0
fedoralibs=0
ubuntulibs=0
if [ $# = 0 ]
then
gnustep=1
paje=1
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
"-uninstall" ) uninstall=1;;
"-make" ) gnustep=1; make=1;;
"-base" ) gnustep=1; base=1;;
"-gui" ) gnustep=1; gui=1;;
"-back" ) gnustep=1; back=1;;
"-remake" ) remake=1;;
"-fedoralibs" ) fedoralibs=1;;
"-ubuntulibs" ) ubuntulibs=1;;
esac
done
fi
if [ $uninstall = 1 ]
then
user=`whoami`
sudo rm -fr $dir
sudo rm -fr /home/$user/GNUstep
sudo rm -fr /usr/GNUstep
exit 0
fi
if [ $remake = 1 ]
then
. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
export LANG=C
if [ $dir != -d ]
then
exit 1
fi
cd $dir
if [ Paje != -d ]
then
exit 2
fi
cd Paje
make -j8
make install GNUSTEP_INSTALLATION_DOMAIN=USER
cd ..
defaults write NSGlobalDomain GSBackend libgnustep-cairo
exit 0
fi
if [ $fedoralibs = 1 ]
then
sudo yum install libxml2-devel libxslt-devel openssl-devel libX11-devel libXext-devel libXt-devel libjpeg*devel libtiff-devel libpng-devel libffi-devel graphviz-devel libmatheval-devel gsl-devel cairo-devel libXfixes-devel libXcursor-devel libXmu-devel libXft-devel libicu-devel clang 
sudo yum groupinstall "Development Tools"
fi
if [ $ubuntulibs = 1 ]
then
sudo apt-get install libxml2-dev libxslt1-dev libssl-dev libx11-dev libxext-dev libxt-dev libjpeg62-dev libtiff4-dev libpng12-dev libffi-dev gobjc build-essential libgraphviz-dev libmatheval1-dev libgsl0-dev libcairo2-dev libpng12-dev libxfixes-dev libxcursor-dev libxmu-dev libxft-dev libicu-dev clang 
fi
export CC=clang
if [ $dir != -d ]
then
mkdir $dir
fi
cd $dir
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
exit 0
