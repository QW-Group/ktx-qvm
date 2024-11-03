#!/bin/sh
if [ ! -f "/src/build_cmake.sh" ]; then
	echo "Could not find KTX source directory!"
	echo
	echo "Enter the project root and invoke something like:"
	echo '$ docker run --rm -v `pwd`:/src ktx-qvm'
	exit 1
fi
cd /src
./build_cmake.sh qvm