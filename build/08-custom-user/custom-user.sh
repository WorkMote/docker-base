#!/bin/bash

# Set the new user account name
NEW_USER_NAME='workmote'

# NOTE: This step of setting the new user's password is no longer enforced, as this user
# won't really need a password to work. However, process is left here just as a reminder
# of how to do this nice random password things :)
#
# Create a random password for the new user. There's no need to know it at any time,
# because of configurations set next won't require user to type it at any time and
# ssh access is only possible using ssh keys.
#NEW_USER_PASS=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)

# Create a new user, meant to be used to access containers, ALWAYS, instead of root.
adduser $NEW_USER_NAME --disabled-password --gecos ''
#echo $NEW_USER_NAME:$NEW_USER_PASS | chpasswd
adduser $NEW_USER_NAME adm
adduser $NEW_USER_NAME sudo
echo "$NEW_USER_NAME ALL=NOPASSWD: ALL" > /etc/sudoers.d/$NEW_USER_NAME
chmod 440 /etc/sudoers.d/$NEW_USER_NAME
