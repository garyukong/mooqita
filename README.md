# mooqita

## Setup directories and repositories
After setting up a new repository using GitHub desktop, changed working directory to where the local repo was stored:
```
(base) Garys-Macbook-Pro:~ garykong$ cd git/mooqita
(base) Garys-Macbook-Pro:mooqita garykong$
```

Cloned darkhttpd and MIDS1D
```
(base) Garys-Macbook-Pro:mooqita garykong$ git clone https://github.com/emikulic/darkhttpd
(base) Garys-Macbook-Pro:mooqita garykong$ git clone https://github.com/dschioberg/MIDS-1D-Computing-Basics
```

Created a working branch and switched to the working branch for this project
```
(base) Garys-Macbook-Pro:mooqita garykong$ git branch working
(base) Garys-Macbook-Pro:mooqita garykong$ git checkout working
```

Open a pull request from working branch to Master branch
```
(base) Garys-Macbook-Pro:mooqita garykong$ git pull origin working
```

Staged and perform initial commit of the readme file to test whether this worked
```
(base) Garys-Macbook-Pro:mooqita garykong$ git add README.md
(base) Garys-Macbook-Pro:mooqita garykong$ git commit -m "First update of README file"
(base) Garys-Macbook-Pro:mooqita garykong$ git push origin working
```

Then did a pull request on github.com/garyukong/mooqita showing good results

## Serve sample website using darkhttp
Installed darkhttpd using homebrew
```
(base) Garys-Macbook-Pro:mooqita garykong$ brew install darkhttpd
```

Extracted website.tar.gz files into a directory called website
```
(base) Garys-Macbook-Pro:mooqita garykong$ tar -xf MIDS-1D-Computing-Basics/website.tar.gz
```

The website directory contained an index.html file and a folder called 'images':

```
(base) Garys-Macbook-Pro:mooqita garykong$ cd website
(base) Garys-Macbook-Pro:website garykong$ ls
images		index.html
```

Served `index.html` (website directory) on port 12345 and opened http://0.0.0.0:12345/ in chrome

```
((base) Garys-Macbook-Pro:mooqita garykong$ darkhttpd website --port 12345
darkhttpd/1.13, copyright (c) 2003-2021 Emil Mikulic.
listening on: http://0.0.0.0:12345/
127.0.0.1 - - [06/Sep/2021:16:07:17 +0700] "GET /Gr%C3%83%C2%A1fico%20de%20dos%20funciones%2001.jpg HTTP/1.1" 500 497 "http://0.0.0.0:12345/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36"
127.0.0.1 - - [06/Sep/2021:16:08:07 +0700] "GET / HTTP/1.1" 500 447 "" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36"
...
```

The following output appeared in chrome: <img src=screenshots/sample-website-render.png>

## Exchange one of the images in the sample index.html and display in browser
With darkhttpd and the browser still open, modified the following code in index.html:

```
<td><img src="Gráfico de dos funciones 01.jpg" alt="" border=3 height=100 width=300></th>
```

to the following:

```
<td><img src="images/4DHypercubeTmason.png" alt="" border=3 height=100 width=300></th>
```

Refreshing the website on chrome led to the image refreshing without needing to restart the server: <img src=screenshots/sample-website-render-2.png>

When the browser requested the file via HTTP (via refreshing the website), the HTTP server (darkhttpd) accepts the request, finds the requested document (index.html, located in the website directory) and sends it back to the browser through http). Because the darkhttpd process continued to be active, it was able to serve index.html without having to restart the server.

## Look up process ID of the server
PS was used to look up the process ID of the server (PID45184) as follows:

```
(base) Garys-MacBook-Pro:mooqita garykong$ ps
  PID TTY           TIME CMD
44770 ttys000    0:00.02 -bash
45184 ttys000    0:00.00 darkhttpd website --port 12345
45209 ttys001    0:00.01 -bash
```

## Shell script to create new index.HTML

Code as follows

```
#!/bin/bash

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
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"> # Added new line to ensure UTF-8 character set is recognized
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
```

The output of the code (titled index.html) was tested using darkhttpd

```
Garys-MacBook-Pro:mooqita garykong$ darkhttpd website_full --port 12345
darkhttpd/1.13, copyright (c) 2003-2021 Emil Mikulic.
listening on: http://0.0.0.0:12345/
```

Output as follows:
<img src=screenshots/website_final-render.png>
