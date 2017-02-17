
all: inputFile.js

%.js: %.coffee
	coffee -c $<

