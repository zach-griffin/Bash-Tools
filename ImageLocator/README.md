Images can contain a lot of data. Modern RAW files are the favorite of professional photographers for the data that is held within the files for better post-shoot adjustments. Steganography is the process of hiding data within an image file, and it is also not what we are discussing today (But for a great read regarding steganography, visit this article by Kevin Salton do Prado), rather we will be looking at hiding images as other data types.
In any investigation, no matter the context, it may become very important to find all images on a system or within a specific directory. But in linux, the file extension doesn’t really matter, meaning that a JPEG file could be renamed as a docx (Microsoft Word format) or a pdf. In this case, most scripts for standard image file extensions will not work. To ensure that we get a full look at all images on a system, we need a script to look at the file itself, not the file extension. We will be scripting using bash!
First thing is script etiquette! Any script you write should have the author, the purpose of the script, the date it was written, and if it is going to be changed often, a version number. For versioning, I like the Major.Minor.Incramental format. We will start at 1.0.0
#!/bin/bash
```
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
```
We want to allow the script to take in a path, or use a default path. To do this, we simply allow for a single input parameter and if none is provided, we set the directory to the current directory.
```
searchDir=$1
if [ "$searchDir" == "" ]
then
    searchDir="$PWD"
fi
Lets loop! We can now create a for loop to iterate on each file in a given directory. Within this loop, we want to set a variable as a command and that command should give us every image that is of type ‘image’. Using some cut commands with piped inputs, we get the variable images that includes all image files under the given directory. Before the loop, we also want to set IFS as a new line to assist with formatting.
IFS=$'\n'
for searchFile in $(find $searchDir); do

 images=$(file -i $searchFile | cut -d':' -f2 | cut -d';' -f1 | grep "image")
```
What if there are no images in the directory? We need to account for that! So within the loop, we set an IF statement like this:
```if [ "$images" != "" ]; then```
The above states: IF the variable $images does not equal null, do the following.
Within this IF statement, we can start echoing the file properties like this:
```
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
done
```
For good measures, we added the MD5 and SHA256 hashes to the list of properties to echo. At the end of this script block, we also closed our for loop.

In summary, we were able to use linux tools like grep, cut, openssl, and more to obtain a list of all image files in a given directory, no matter the file extension that has been set.
