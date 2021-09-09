#!/bin/bash

# Bash script to create new website containing all images

## Set script parameters
title="Math Collection - Index of Images"
header="Math Collection"
imgperrow=5
border=3
height=80
width=200
bordercolor=black
alignment=center
tableborder=5
dir=website_full/images # Location of directory containing all images

## Rename all files into UTF-8 format to ensure compatibility with HTML
cd $dir
convmv -f windows-1252 -t utf-8 * --notest
convmv -f cp850 -t utf-8 * --notest
convmv -f ISO-8859-1 -t utf-8 * --notest
cd ../..

## Create a variable containing all filenames for later use in a for loop
OIFS="$IFS" # Backs up current Bash internal field separator value
IFS=$'\n' # Ensures that each item in the list is delimited by a line break
dirlist=`find $dir -type f | sort` # Lists all files in the directory, sorts and saves it into variable called $dirlist
dirlist=`basename $dirlist` # Removes names of directories in $dirlist

## Create a variable containing HTML code for each filename, moving into new line after specified number of images
counter=1 # Set starting counter value at 1. Used in for loop to
# index=1 # Set starting index value at 1. Was used for testing that the code captured all 159 images in the directory
imgcode=$(for file in $dirlist
          do
          if [[ $counter -eq 1 ]]; then
            echo "        <tr>"
            # echo fileno = $index # Prints file number to ensure all files have been captured
            echo "            <td><img src='"images/$file"' alt="" border=$border height=$height width=$width></th>"
            ((counter=$counter+1))
            # ((index=$index+1))
          elif [[ $counter -gt 1 && $counter -lt $imgperrow ]]; then
            # echo fileno = $index # Prints file number to ensure all files have been captured
            echo "            <td><img src='"images/$file"' alt="" border=$border height=$height width=$width></th>"
            ((counter=$counter+1))
            # ((index=$index+1))
          else
            # echo fileno = $index # Prints file number to ensure all files have been captured
            echo "            <td><img src='"images/$file"' alt="" border=$border height=$height width=$width></th>"
            echo "        </tr>"
            counter=1
            # ((index=$index+1))
          fi
        done)
      # echo $imgcode # Just used to check that the code has been written correctly

## Write an HTML file using variable substitution to insert the code corresponding to the images
outfile=website_full/index.html
(
cat << _EOF_
    <!doctype html>
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"> # Added
        <title>$title</title>
      </head>
      <body>
       <center>
        <h1>$header</h1>
       </center>
      <table border="$tableborder" bordercolor="$bordercolor" align="$alignment">
        <tr>
            <th colspan="$imgperrow">PICTURES</th>
        </tr>
        $imgcode # Substitutes outputs of the for loop into HERE DOC
      </table>
      </body>
    </html>
_EOF_
) > $outfile
