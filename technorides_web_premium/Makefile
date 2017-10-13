# Use `bash` instead of `sh`, empowers syntax:
SHELL := /bin/bash

# Run four parallel jobs by default:
MAKEFLAGS := '-j 4'

# Find sources and targets for files we need to compile or copy:
CS_FILES   := $(shell find . -type f -not -path './www/*' -name '*.coffee')
SASS_FILES := $(shell find . -type f -not -path './www/*' -name '*.sass')
JADE_FILES := $(shell find . -type f -not -path './www/*' -name '*.jade')

JS_FILES   := $(CS_FILES:%.coffee=www/%.js)
CSS_FILES  := $(SASS_FILES:%.sass=www/%.css)
HTML_FILES := $(JADE_FILES:%.jade=www/%.html)

ASSET_DIRS := $(shell \
	find . -type d -name 'assets' \
		-not -path './www/*'    \
		-not -path './common/*' \
) common/ map/


default: build
	# ls -1 | grep -v '^www$|^Makefile$'


js: $(JS_FILES)

www/%.js: %.coffee
	mkdir -p $(dir $@) # Create directory path to compiled file
	coffee -co $(dir $@) $^
	echo -e coffee '\t' $^


css: $(CSS_FILES)

www/%.css: %.sass
	mkdir -p $(dir $@) # Create directory path to compiled file
	sass -t compressed $^ $@
	echo -e sass '\t' $^


html: $(HTML_FILES)

www/%.html: %.jade
	mkdir -p $(dir $@) # Create directory path to compiled file
	jade --pretty -o $(dir $@) $^ > /dev/null # Supress irritating output, not stderr
	echo -e jade '\t' $^


.PHONY: assets $(ASSET_DIRS)
assets: $(ASSET_DIRS)

$(ASSET_DIRS): %:
	mkdir -p www/$@
	if [[ $$(rsync -i --archive $@/ www/$@) ]]; then echo -e sync '\t' $@; fi


.PHONY: build
build: js css html assets
	# HACK ALERT! The `select` plugin requires this file to exist in exactly
	# this form and path. We humor it.
	mkdir -p www/select
	cp select/select.tpl.html www/select/
	# mkdir -p www/legacy
	# cp -r legacy/* www/

clean:
	rm -rf www/


serve:build
	serb www --address 127.0.0.1 --header "cache-control: max-age=86400, must-revalidate"

run_dev:
	make serve & make cycle


cycle:
	relo --group $$(ls -1 | grep -v www) -- make

#make produ ENV=alpha


deploy_prod:
	rsync -r www/ ../technorides_www/production/

deploy_alpha:
	rsync -r www/ ../technorides_www/alpha/

deploy_beta:
	rsync -r www/ ../technorides_www/beta/

deploy: deploy_beta deploy_alpha deploy_prod

#THIS CHECK IS APPLYING TO ALL THE MAKE, FIXIT
check-env:
ifdef ENV
	echo $(ENV)
  #export ENV = $(ENV)
endif
ifndef ENV
  #export ENV = "production"
endif

# ------------------------------------------------------------------------------
# NGINX CONFIGURATION:

nginx-install: build
	echo "Stopping nginx..."
	service nginx stop

	echo "Installing site and copying files..."
	cp config/nginx/tr_premium.conf /etc/nginx/sites-available/
	rm -rf /www
	cp -r www /

	echo "Restarting nginx..."
	service nginx start

	echo "done."


nginx-uninstall:
	echo "Uninstalling site and removing files..."
	rm -f /etc/nginx/sites-{enabled,available}/tr_premium.conf
	rm -rf /www

	echo "done."


nginx-enable:
	stat /etc/nginx/sites-available/tr_premium.conf > /dev/null # fail if not installed
	cd /etc/nginx/sites-enabled && ln -fs ../sites-available/tr_premium.conf .
	service nginx reload


nginx-disable:
	rm -f /etc/nginx/sites-enabled/tr_premium.conf
	service nginx reload


# Supress command echoing for all targets:
.SILENT:
