
all: inputFile.js cacheImage.js googleMapWraper.js errorSpeaker.js imageList.js

%.js: %.coffee
	coffee -c $<

