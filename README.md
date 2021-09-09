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
