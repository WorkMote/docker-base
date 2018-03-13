#!/bin/bash

# Purpose: Enable keychain and with that ssh-agent on user login
#
# All credit and recognition to VIVEK GITE, under GPL v2.0+
# http://www.cyberciti.biz/faq/ubuntu-debian-linux-server-install-keychain-apt-get-command/
#
# It's just a generalization of the solution there proposed.
# Daniel Dalgo <dalguete@gmail.com>
#

#####################################################################################
### The --clear option make sure "Intruder" cannot use your existing SSH-Agents keys 
### i.e. Only allow cron jobs to use password less login 
#####################################################################################
keychain --clear
. $HOME/.keychain/$HOSTNAME-sh
