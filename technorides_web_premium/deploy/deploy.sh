#!/bin/bash
cd /home/ubuntu/technorides_web_premium.alpha
git checkout development
git pull
make
make deploy_alpha
