killall /usr/local/lib/node_modules/protractor/selenium/chromedriver
killall java
webdriver-manager start &
sleep 5
protractor test/js/config.js
