# mooqita

## Initial setup
Change working directory
```
cd git/mooqita
```

Clone darkhttpd
```
git clone https://github.com/emikulic/darkhttpd
```

Clone MIDS1D folder
```
git clone https://github.com/dschioberg/MIDS-1D-Computing-Basics
```

Create a working branch
```
git branch working
```

Open a pull request from working branch to Master branch
```
git pull origin working
git pull
```

Stage and perform initial commit of the readme file
```
git add README.md
git commit -m "First update of README file"
git push origin/working
```
