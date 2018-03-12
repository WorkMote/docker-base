#!/bin/bash

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
