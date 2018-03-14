#!/bin/bash

################
# SSH (Client) #
################
# (DEPRECATED)
# # Set ssh-agent to auto add keys. It's assumed target file (/etc/ssh/ssh_config) has
# # no 'AddKeysToAgent' key defined yet, so it's safe to simply add it. However, if 
# # that file has been modified previously in a way more Hosts are set, act differently
# # so you can be sure the effect of adding this flag won't mean a problem for other
# # configs already set.
# echo '    AddKeysToAgent yes' >> /etc/ssh/ssh_config

# # Install the keychain starter file to affect every connected user.
# mv $(cd `dirname $0` && pwd)/keychain-starter.sh /etc/profile.d/

#################
# SSHD (Server) #
#################
# Prevent root access or password access by any user without a key already stablished.
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/; s/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Maybe not the best place to put this, but after tests, it was found the ssh service
# was not starting as expected, due to the lack of a folder.
# It said "Missing privilege separation directory: /run/sshd"
# But it can be a bit different path with the same message. What was found is when the 
# service is started for the first time, it does some things that will remove problems,
# so, that service is explicitely started and stopped here to have all strings attached.
service ssh start
service ssh stop
