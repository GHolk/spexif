
ftp_in_gvfs = ~/gvfs/ftp:host=140.116.80.138/www

all: server front_end

publish: front_end
	cp -f ext/*.js ext/*.css $(ftp_in_gvfs)/exifmap/ext/
	cp -f index.html $(ftp_in_gvfs)/exifmap/

front_end: ext/*.js

server: index.js node_modules/*.js

%.js: %.coffee
	coffee -c $<

.PHONY: server front_end

