# Coffee-script and folders
mkdir common
cd common
mkdir js
mkdir css

coffeebar -mo js coffee

cd ..
mkdir technorides
cd technorides
mkdir js
mkdir css

coffeebar -mo js coffee

cd ..
mkdir booking
cd booking
mkdir js
mkdir css

coffeebar -mo js coffee

cd ..
mkdir dispatcher
cd dispatcher
mkdir js
mkdir css

coffeebar -mo js coffee

cd ..
mkdir login
cd login
mkdir js
mkdir css

coffeebar -mo js coffee

cd ..
mkdir dashboard
cd dashboard
mkdir js
mkdir css

coffeebar -mo js coffee

cd ..
mkdir test
cd test
mkdir js

coffeebar -mo js coffee

cd ..
mkdir landings
cd landings
mkdir js
mkdir css

coffeebar -mo js coffee

cd ..
mkdir signup
cd signup
mkdir js
mkdir css

coffeebar -mo js coffee
# Jade
cd ..
jade .

# SASS
sass -t compressed -f --update common/sass:common/css
sass -t compressed -f --update technorides/sass:technorides/css
sass -t compressed -f --update booking/sass:booking/css
sass -t compressed -f --update dispatcher/sass:dispatcher/css
sass -t compressed -f --update login/sass:login/css
sass -t compressed -f --update dashboard/sass:dashboard/css
sass -t compressed -f --update signup/sass:signup/css
sass -t compressed -f --update landings/1/sass:landings/1/css
sass -t compressed -f --update landings/2/sass:landings/2/css
sass -t compressed -f --update landings/3/sass:landings/3/css
