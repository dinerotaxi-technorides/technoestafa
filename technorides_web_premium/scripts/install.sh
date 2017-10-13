# Git Hook
cp requirements/post-merge .git/hooks/
chmod +x .git/hooks/post-merge

# Koala
sudo dpkg -i requirements/koala_2.0.3_amd64.deb

# Fix Koala lib issues
sudo ln -sf /lib/$(arch)-linux-gnu/libudev.so.1 /lib/$(arch)-linux-gnu/libudev.so.0

# NodeJS, npm and Ruby
sudo apt-get update
sudo apt-get install nodejs npm ruby apache2
sudo ln -s /usr/bin/nodejs /usr/bin/node

# Coffeebar, Jade and protractor
sudo npm -g install coffeebar jade protractor serb relo

# SASS
sudo gem install sass

# Protractor web-driver update
sudo webdriver-manager update

# Apache configuration
sudo rm -rf /var/www
sudo ln -s $(pwd) /var/www

sudo mkdir /etc/apache2/sites-enabled-old/
sudo mv /etc/apache2/sites-enabled/* /etc/apache2/sites-enabled-old/
sudo cp requirements/apache.conf /etc/apache2/sites-enabled/

sudo apache2ctl restart

# First compilation
sh scripts/compile.sh
