Technorides
===

Installation
---
Install all dev dependencies
coffeescript:

    npm install -g coffee-script
jade:

    npm install jade
SASS OSX: 

    gem install sass
SASS Linux:

    sudo su -c "gem install sass"

Also you need to have GNU commands available, (thx to an asshole)
if you have Mac computers you need to <a href="https://www.topbug.net/blog/2013/04/14/install-and-use-gnu-command-line-tools-in-mac-os-x/">install gnu commands with homebrew</a>

Run and compile
---
serve files on port 8000

    make serve
watch files and compile on change
    
    make cycle


Testing
---
In the project's base folder run the following command:

    protractor test/js/config.js

Sub-Projects
---
* **booking**
* common
* **dashboard**
* **dispatcher**
* landings
* signup
* **technorides**
* test

Sub-Projects' Folders
---

###coffee

* config
* controllers
* directives
* filters
* services
 * api
 * models
 * websocket

###sass
###views

Deploy
---
<code>ssh -i your/route/to/RubyProduction.pem ubuntu@technorides.eu</code><br>
<code>cd technorides_web_premium</code><br>
<code>git pull origin development</code><br>
<code>make</code><br>
<code>make deploy_prod</code><br>
