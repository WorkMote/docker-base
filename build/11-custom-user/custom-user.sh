#!/bin/bash

# Add a script that will copy ssh keys (if present) passed to running container
# to be used in ssh access process.
mv $(cd `dirname $0` && pwd)/scripts/access-custom-user-init /usr/local/bin/

# Add a script to complain when root user was used to login.
mv $(cd `dirname $0` && pwd)/scripts/only-root-user-complainer.sh /etc/profile.d/

# Store the name of the custom user created in the system, so it can be later
# retrieved and processed for any means
echo "$CustomUsername" > /opt/custom-user-name
chmod 0400 /opt/custom-user-name

## NOTE: This step of setting the new user's password is no longer enforced, as this user
## won't really need a password to work. However, process is left here just as a reminder
## of how to do this nice random password things :)
##
## Create a random password for the new user. There's no need to know it at any time,
## because of configurations set next won't require user to type it at any time and
## ssh access is only possible using ssh keys.
# CustomUserPass=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)

# Create a new user, meant to be used to access containers, ALWAYS, instead of root.
adduser $CustomUsername --disabled-password --gecos ''
#echo $CustomUsername:$CustomUserPass | chpasswd
adduser $CustomUsername adm
adduser $CustomUsername sudo
echo "$CustomUsername ALL=NOPASSWD: ALL" > /etc/sudoers.d/$CustomUsername
chmod 440 /etc/sudoers.d/$CustomUsername

# Set ready the ".ssh" folder in user's home
CustomUserHome=$(getent passwd "$CustomUsername" | cut -d: -f6)
mkdir -p "$CustomUserHome/.ssh/"
chown "$CustomUsername.$CustomUsername" "$CustomUserHome/.ssh/"
chmod 0700 "$CustomUserHome/.ssh/"