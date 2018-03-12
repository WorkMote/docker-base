#!/bin/bash
#
# Current script folder technique, as found here
# https://www.electrictoolbox.com/bash-script-directory/
debconf-set-selections $(cd `dirname $0` && pwd)/debconf-set-selections