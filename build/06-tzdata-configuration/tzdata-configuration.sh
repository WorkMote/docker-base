#!/bin/bash

# America/Guayaquil timezone is used to configure image.
# https://stackoverflow.com/a/40923787
ln -sf /usr/share/zoneinfo/America/Guayaquil /etc/localtime
dpkg-reconfigure -f noninteractive tzdata
