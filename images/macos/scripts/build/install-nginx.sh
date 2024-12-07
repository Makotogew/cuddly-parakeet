#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-nginx.sh
##  Desc:  Install Nginx
################################################################################

source ~/utils/utils.sh

brew_smart_install nginx
sudo sed -Ei '' 's/listen.*/listen 80;/' $(brew --prefix)/etc/nginx/nginx.conf

invoke_tests "WebServers" "Nginx"
