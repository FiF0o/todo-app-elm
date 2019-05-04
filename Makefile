build:
	elm make src/Main.elm --optimize --output=./dist/index.js

markup:
		rm ./dist/index.min.html \
		&& cp ./public/index.html ./dist/index.html \
		&& cat ./dist/index.html | sed "s/index.js/index.min.js/" > ./dist/index.tmp.html \
		&& ./node_modules/.bin/minify ./dist/index.tmp.html > ./dist/index.min.html \
		&& rm ./dist/index.html ./dist/index.tmp.html \
		&& echo 'markup done'

production: build markup
	./node_modules/.bin/uglifyjs ./dist/index.js --compress "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe" | ./node_modules/.bin/uglifyjs --mangle --output=./dist/index.min.js \
	&& rm ./dist/index.js \
	&& echo 'production build done'

dev:
	elm reactor