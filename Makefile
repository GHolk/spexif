
all: inputFile.js cacheImage.js googleMapWraper.js

%.js: %.coffee
	coffee -c $<

