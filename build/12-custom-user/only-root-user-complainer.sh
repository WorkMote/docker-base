#!/bin/sh

# Purpose: Display all regular users who can access the system.
#
# All credit and recognition to VIVEK GITE, under GPL v2.0+
# http://www.cyberciti.biz/faq/linux-list-users-command/
#
# I just did some little adjustments to get my goal of only
# display regular user if there are.
# Daniel Dalgo <dalguete@gmail.com>
#

# Set some coloring
RED='\033[0;31m'
LIGHTRED='\033[1;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
LIGHTGREEN='\033[1;32m'
NC='\033[0m' # No Color

# Get sources of info
_l="/etc/login.defs"
_p="$(getent passwd)"

## get mini UID limit ##
l=$(grep "^UID_MIN" $_l)

## get max UID limit ##
l1=$(grep "^UID_MAX" $_l)

## use awk to print if UID >= $MIN and UID <= $MAX and shell is not /sbin/nologin   ##
count=`echo "$_p" | awk -F':' -v "min=${l##UID_MIN}" -v "max=${l1##UID_MAX}" '{ if ( $3 >= min && $3 <= max && $7 != "/sbin/nologin" ) print $1 }' | wc -l`

# Check the current user is root or there are no other regular users, to show a warning!!!
if [ `id -u` = 0 -o $count = 0 ]; then
	echo -e >&2 "${RED}IMPORTANT!!!${NC}\n\
${ORANGE}Use of 'root' is discouraged.\nPlease, work with a different user or create a new one.${NC}\n\
Suggestion, check ${GREEN}adduser${NC} command.\n"
fi