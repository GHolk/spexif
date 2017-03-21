
all: \
	inputFile.js \
	cacheImage.js \
	googleMapWraper.js \
	errorSpeaker.js \
	imageList.js \
	filterPiexif.js \
	domHelper.js

%.js: %.coffee
	coffee -c $<

