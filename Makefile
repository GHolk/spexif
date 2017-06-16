
all: server front_end

publish: front_end
	cp -f ext/*.js ~/gvfs/ftp:host=140.116.80.138/www/exifmap/ext/

front_end: ext/*.js

server: index.js node_modules/*.js

%.js: %.coffee
	coffee -c $<

.PHONY: server front_end

