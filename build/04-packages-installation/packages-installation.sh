#!/bin/bash
apt-get update

# To disable entries on a multiline command, this backtick technique was used
# https://stackoverflow.com/a/12797512
#
# Expensive, yes, but did the work. In General, DO NOT DO THAT!!! I have some special
# blessing, you know!
apt-get install -y \
  bash-completion \
  bindfs \
  `# build-essential` \
  bsdmainutils \
  debconf-utils \
  dnsutils \
  iproute2 \
  iputils-ping \
  `# keychain` \
  less \
  locales \
  man-db \
  nano \
  netcat-openbsd \
  openssh-server \
  python-software-properties \
  rar \
  software-properties-common \
  squashfs-tools \
  squashfuse \
  snapd \
  sudo \
  supervisor \
  telnet \
  tzdata \
  unrar \
  zip

# Snap packages requirements installation. In general these packages can be installed by processes
# triggered when the snap is set, but that could require a new apt-get complete process, possibly ending
# in a not so fast container start, etc. Also, putting them here help us control and understand structure
# better.
apt-get install -y \
  bindfs \
  git

