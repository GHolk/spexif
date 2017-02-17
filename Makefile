
all: inputFile.js cacheImage.js

%.js: %.coffee
	coffee -c $<

