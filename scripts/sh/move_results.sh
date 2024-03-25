#!/bin/bash

cwd=$(PWD)
echo "current directory: ${cwd}"
destination=$cwd/../../../../../results/
echo "destination directory: ${destination}"

cd "${destination}"
echo "${PWD}"

if [ "$#" -eq 2 ]
then
	if [ ! -d "${2}" ];
	then
		mkdir "${2}"
	fi
	cp -r "${1}" "${2}/"
else
	cp -r ${1} .
fi
