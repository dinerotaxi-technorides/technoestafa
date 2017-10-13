CS_FILES = $(shell find src -name '*.coffee')
JS_FILES = $(patsubst src/%.coffee, gen/%.js, $(CS_FILES))


build: gen $(JS_FILES)

gen:
	mkdir gen

gen/%.js: src/%.coffee
# $< is the input file, $@ the output file
	@mkdir -p `dirname $(@)`
	coffee --map --compile --output `dirname $(@)` $(<)

clean:
	rm -rf gen

install_new:
	npm install node-gcm

watch:
	 watch -n1 date

change_date:
	sudo date -s "12 Sep 2016 18:04:40"
aws_run: build
	export NODE_ENV=production
	cp config_aws_prod.json config.json
	node --max-old-space-size=3000 gen/main.js
	serb # blocks until interrupted
	killall node

aws_run_slave: build
	export NODE_ENV=production
	rm -rf gen/v3
	# cp -R src/v3 gen/v3
	cp src/v3/config/newrelic/prod.js gen/newrelic.js
	cp config_aws_slave.json config.json
	node gen/main.js
	serb # blocks until interrupted
	killall node

aws_set_time:
	watch -n1 date
	sudo date -s "20 Jun 2016 12:42:10"

pre_aws_run: build
	export NODE_ENV=stage
	cp config_pre_aws_prod.json config.json
	node gen/main.js
	serb # blocks until interrupted
	killall node

run_dev:build
	cp config_dev.json config.json
	rm -rf gen/v3
	cp -R src/v3 gen/v3
	cp src/v3/config/newrelic/ci.js gen/newrelic.js
	node gen/main.js
	# serb # blocks until interrupted
	# killall node

run_ci:build
	cp config_ci.json config.json
	rm -rf gen/v3
	cp -R src/v3 gen/v3
	cp src/v3/config/newrelic/ci.js gen/newrelic.js
	node gen/main.js
	# serb # blocks until interrupted
	# killall node

run_beta:build
	cp config_beta.json config.json
	rm -rf gen/v3
	cp -R src/v3 gen/v3
	cp src/v3/config/newrelic/beta.js gen/newrelic.js
	node gen/main.js
	# serb # blocks until interrupted
	# killall node

client: build
	google-chrome localhost:8000/


deps:
	@sudo npm install -g   \
		coffee-script      \
		serb 		       \
		sudo apt-get install libkrb5-dev
		sudo npm install -g agenda@0.6.28
		sudo npm install -g body-parser@1.8.1
		sudo npm install -g cluster@0.7.7
		sudo npm install -g crypto@0.0.3
		sudo npm install -g exit@0.1.2
		sudo npm install -g express@4.9.0
		sudo npm install -g express-domain-middleware@0.1.0
		sudo npm install -g geojson-utils@1.1.0
		sudo npm install -g googlemaps@0.1.20
		sudo npm install -g hiredis@0.1.17
		sudo npm install -g knex@0.6.22
		sudo npm install -g mongoose@4.0.1
		sudo npm install -g moment@2.8.3
		sudo npm install -g mysql@2.5.0
		sudo npm install -g mongoose-geojson-schema@0.0.2
		sudo npm install -g nodemailer@1.3.0
		sudo npm install -g point-in-polygon@0.0.0
		sudo npm install -g q@1.0.1
		sudo npm install -g request@2.42.0
		sudo npm install -g redis@0.12.1
		sudo npm install -g source-map-support@0.2.7
		sudo npm install -g turf-intersect@1.4.2
		sudo npm install -g winston@0.8.0
		sudo npm install -g ws@0.4.32
		# lastest version
		# sudo npm install  agenda@0.6.28
		# sudo npm install  body-parser@1.14.1
		# sudo npm install  express@4.13.3
		# sudo npm install  googlemaps@1.0.2
		# sudo npm install  hiredis@0.4.1
		# sudo npm install  knex@0.9.0
		# sudo npm install  mongoose@4.2.4
		# sudo npm install  moment@2.10.6
		# sudo npm install  mysql@2.9.0
		# sudo npm install  nodemailer@1.8.0
		# sudo npm install  point-in-polygon@1.0.0
		# sudo npm install  q@1.4.1
		# sudo npm install  request@2.65.0
		# sudo npm install  redis@2.3.0
		# sudo npm install  source-map-support@0.3.3
		# sudo npm install  winston@2.1.0
		# sudo npm install  ws@0.8.0
