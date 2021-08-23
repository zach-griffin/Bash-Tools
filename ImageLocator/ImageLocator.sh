#!/bin/bash

#
# ImageLocator Script
#
# PURPOSE:
# The purpose of this script is to search a given directory
# for files that are images, no matter the extension name,
# and returning information regarding that file.
#
# Written February 2020
# By Zach Griffin
#
searchDir=$1
if [ "$searchDir" == "" ]
then
    searchDir="$PWD"
fi

IFS=$'\n'

for searchFile in $(find $searchDir); do

 images=$(file -i $searchFile | cut -d':' -f2 | cut -d';' -f1 | grep "image")
 if [ "$images" != "" ]; then
   echo ""

   echo "File Name:    $(basename $searchFile)"

   owner=$(ls -l $searchFile | cut -d' ' -f3)
   echo "File Owner:   $owner"

   echo "File Path:    $searchFile"

   fileType=$(file -i $searchFile | cut -d':' -f2 | cut -d' ' -f2 | cut -d'/' -f2 | cut -d';' -f1)
   echo "File Type:    $fileType"

	md5Hash=$(openssl md5 $searchFile | cut -d'=' -f2 | cut -d' ' -f2)
	sha256Hash=$(openssl sha256 $searchFile | cut -d'=' -f2 | cut -d' ' -f2)
	echo "MD5:          $md5Hash"
	echo "SHA256:       $sha256Hash"

   echo ""
 fi

done
