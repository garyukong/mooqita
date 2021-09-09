#!/bin/bash

## Set parameters for the HTML file
title="Math Collection - Index of Images"
header="Math Collection"
imgperrow=5
border=3
height=80
width=200
bordercolor=black
alignment=center
tableborder=5

## Create a variable containing all filenames
dir=website_full/images # Set location of directory containing all images

## RENAME FILES SPECIAL CHARACTERS HERE - add convmv code to ensure all images are UTF-8 charset
cd $dir
convmv -f windows-1252 -t utf-8 * --notest
convmv -f cp850 -t utf-8 * --notest
convmv -f ISO-8859-1 -t utf-8 * --notest
cd ../..

## SAVE FILENAMES VARIABLE
OIFS="$IFS" # Backs up current Bash internal field separator value
IFS=$'\n' # Ensures that each item in the list is delimited by a line break
dirlist=`find $dir -type f | sort` # Lists all files in the directory, sorts and saves it into variable called $dirlist
dirlist=`basename $dirlist` # Removes names of directories in $dirlist

## Create a variable containing HTML code for each filename, moving into new line after specified number of images
counter=1
index=1
imgcode=$(for file in $dirlist
          do
          if [[ $counter -eq 1 ]]; then
            echo "        <tr>"
            # echo fileno = $index # Prints file number to ensure all files have been captured
            echo "            <td><img src='"images/$file"' alt="" border=$border height=$height width=$width></th>"
            ((counter=$counter+1))
            # ((index=$index+1))
            # echo count = $counter
          elif [[ $counter -gt 1 && $counter -lt $imgperrow ]]; then
            # echo fileno = $index # Prints file number to ensure all files have been captured
            echo "            <td><img src='"images/$file"' alt="" border=$border height=$height width=$width></th>"
            ((counter=$counter+1))
            # ((index=$index+1))
            # echo count = $counter
          else
            # echo fileno = $index # Prints file number to ensure all files have been captured
            echo "            <td><img src='"images/$file"' alt="" border=$border height=$height width=$width></th>"
            echo "        </tr>"
            counter=1
            # ((index=$index+1))
            # echo count = $counter
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
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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
        $imgcode
      </table>
      </body>
    </html>
_EOF_
) > $outfile
