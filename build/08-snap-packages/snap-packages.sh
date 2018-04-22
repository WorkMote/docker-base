#!/bin/bash

# Create a snaps hosting folder
mkdir /my-snap

# Create the snaps folder, if not there already
if [ ! -d /snap ]; then
  mkdir /snap
fi

# Move every single snap passed to the hosting place.
mv $(cd `dirname $0` && pwd)/snap-packages/*.snap /my-snap/

# Move the snaps starter script to the system.
mv $(cd `dirname $0` && pwd)/my-snaps-starter /usr/local/bin/

# As snaps will be triggered in a super custom fashion, to avoid snap/docker
# function problem, the /snap folder is prepared to receive our scripts.
mkdir -p /snap/bin
mkdir -p /snap/share
mv $(cd `dirname $0` && pwd)/snap-share/* /snap/share/

# Move the my bindfs mounter script to the system.
mv $(cd `dirname $0` && pwd)/my-bindfs-mounts-init /usr/local/bin/
