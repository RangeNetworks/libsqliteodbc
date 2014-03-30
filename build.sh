#!/bin/bash

VERSION=0.995

sayAndDo () {
	echo $@
	eval $@
	if [ $? -ne 0 ]
	then
		echo "ERROR: command failed!"
		exit 1
	fi
}

installIfMissing () {
	dpkg -s $@ > /dev/null
	if [ $? -ne 0 ]; then
		echo " - oops, missing $@, installing"
		sudo apt-get install $@
	else
		echo " - $@ ok"
	fi
	echo
}

if [ ! -f sqliteodbc-$VERSION.tar.gz ]
then
	sayAndDo wget http://www.ch-werner.de/sqliteodbc/sqliteodbc-$VERSION.tar.gz
fi

if [ -d sqliteodbc-$VERSION ]
then
	sayAndDo rm -rf sqliteodbc-$VERSION
fi

sayAndDo tar zxf sqliteodbc-$VERSION.tar.gz
sayAndDo cp debian/* sqliteodbc-$VERSION/debian/
sayAndDo patch -p0 < add_retries.patch
sayAndDo cd sqliteodbc-$VERSION
sayAndDo dpkg-buildpackage -us -uc

