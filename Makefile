
all: server front_end

front_end: ext/*.js

server: index.js node_modules/*.js

%.js: %.coffee
	coffee -c $<

.PHONY: server front_end

