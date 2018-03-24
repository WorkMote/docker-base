#!/bin/bash

# Add a script that will copy ssh keys (if present) passed to running container
# to be used in ssh access process.
mv $(cd `dirname $0` && pwd)/access-custom-user /usr/local/bin/

# Add a script to complain when root user was used to login.
mv $(cd `dirname $0` && pwd)/only-root-user-complainer.sh /etc/profile.d/

# Prepare the new user name var to be used in further scripts run.
export CUSTOM_USER_NAME

# Store the name of the custom user created in the system, so it can be later
# retrieved and processed for any means
echo "$CUSTOM_USER_NAME" > /opt/custom-user-name
chmod 0400 /opt/custom-user-name

# NOTE: This step of setting the new user's password is no longer enforced, as this user
# won't really need a password to work. However, process is left here just as a reminder
# of how to do this nice random password things :)
#
# Create a random password for the new user. There's no need to know it at any time,
# because of configurations set next won't require user to type it at any time and
# ssh access is only possible using ssh keys.
#CUSTOM_USER_PASS=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)

# Create a new user, meant to be used to access containers, ALWAYS, instead of root.
adduser $CUSTOM_USER_NAME --disabled-password --gecos ''
#echo $CUSTOM_USER_NAME:$CUSTOM_USER_PASS | chpasswd
adduser $CUSTOM_USER_NAME adm
adduser $CUSTOM_USER_NAME sudo
echo "$CUSTOM_USER_NAME ALL=NOPASSWD: ALL" > /etc/sudoers.d/$CUSTOM_USER_NAME
chmod 440 /etc/sudoers.d/$CUSTOM_USER_NAME

# Set ready the ".ssh" folder in user's home
CUSTOM_USER_HOME=$(getent passwd "$CUSTOM_USER_NAME" | cut -d: -f6)
mkdir -p "$CUSTOM_USER_HOME/.ssh/"
chown "$CUSTOM_USER_NAME.$CUSTOM_USER_NAME" "$CUSTOM_USER_HOME/.ssh/"
chmod 0700 "$CUSTOM_USER_HOME/.ssh/"