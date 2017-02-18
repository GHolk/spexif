
all: inputFile.js cacheImage.js googleMapWraper.js errorSpeaker.js

%.js: %.coffee
	coffee -c $<

