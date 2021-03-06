FROM ubuntu:17.10

# Version number for WorkMote's Docker Base Image.
LABEL com.workmote.we.base.version="0.1"
# Maintainer for WorkMote's Docker Base Image.
LABEL com.workmote.we.base.maintainer="Daniel Dalgo <dalguete@gmail.com>"
# Purpose of anything here installed for WorkMote's Docker Base Image.
LABEL com.workmote.we.base.purpose="base"
# Application name here installed for WorkMote's Docker Base Image.
LABEL com.workmote.we.base.app="base"

# To avoid having errors like "unable to initialize frontend: Dialog" when packages
# are upgraded/installed.
ARG DEBIAN_FRONTEND=noninteractive

# Start everything as the expected (generally) root user, so there won't be
# installation problems in case base image has set USER to something different.
USER root

# 00
# Prompt setup process.
COPY 00-prompt-setup/ /tmp/00-prompt-setup/
RUN /tmp/00-prompt-setup/prompt-setup.sh \
  && rm -r /tmp/00-prompt-setup/

# 01
# Start up processes after installation policy
COPY 01-start-up-policy/ /tmp/01-start-up-policy/
RUN /tmp/01-start-up-policy/start-up-policy.sh \
  && rm -r /tmp/01-start-up-policy/

# 02
# Load debconf selections for packages to be installed.
COPY 02-packages-defaults/ /tmp/02-packages-defaults/
RUN /tmp/02-packages-defaults/packages-defaults.sh \
	&& rm -r /tmp/02-packages-defaults/

# 03
# System upgrade.
COPY 03-system-upgrade/ /tmp/03-system-upgrade/
RUN /tmp/03-system-upgrade/system-upgrade.sh \
  && rm -r /tmp/03-system-upgrade/

# 04
# Packages installation.
COPY 04-packages-installation/ /tmp/04-packages-installation/
RUN /tmp/04-packages-installation/packages-installation.sh \
  && rm -r /tmp/04-packages-installation/
EXPOSE 22

# 05
# ssh/sshd configuration.
COPY 05-ssh-sshd-configuration/ /tmp/05-ssh-sshd-configuration/
RUN /tmp/05-ssh-sshd-configuration/ssh-sshd-configuration.sh \
  && rm -r /tmp/05-ssh-sshd-configuration/

# 06
# tzdata configuration.
COPY 06-tzdata-configuration/ /tmp/06-tzdata-configuration/
RUN /tmp/06-tzdata-configuration/tzdata-configuration.sh \
  && rm -r /tmp/06-tzdata-configuration/

# 07
# locales configuration. It's necessary to define env variables, that way
# any container started from this will have correct values set.
ENV LANG=en_US.UTF-8 \
  LANGUAGE= \
  LC_CTYPE="en_US.UTF-8" \
  LC_NUMERIC=es_EC.UTF-8 \
  LC_TIME=es_EC.UTF-8 \
  LC_COLLATE="en_US.UTF-8" \
  LC_MONETARY=es_EC.UTF-8 \
  LC_MESSAGES="en_US.UTF-8" \
  LC_PAPER=es_EC.UTF-8 \
  LC_NAME=es_EC.UTF-8 \
  LC_ADDRESS=es_EC.UTF-8 \
  LC_TELEPHONE=es_EC.UTF-8 \
  LC_MEASUREMENT=es_EC.UTF-8 \
  LC_IDENTIFICATION=es_EC.UTF-8 \
  LC_ALL=

# 08
# snap packages configuration.
COPY 08-snap-packages/ /tmp/08-snap-packages/
RUN /tmp/08-snap-packages/snap-packages.sh \
  && rm -r /tmp/08-snap-packages/
ENV PATH="${PATH}:/snap/bin"

# 09
# Set the external volume mount place, to be filled with any data meant to be persisted
# when the container is running.
VOLUME /data/

# 10
# Setup the default welcome message process.
COPY 10-welcome/workmote.sh /opt/

# 11
# Custom user configuration.
ARG CustomUsername="workmote"
COPY 11-custom-user/ /tmp/11-custom-user/
RUN /tmp/11-custom-user/custom-user.sh \
  && rm -r /tmp/11-custom-user/

# 12
# Set the main processes for supervisor to run. The reason of containers using this image.
COPY 12-supervisor/ /etc/supervisor/conf.d/

# 13
# Perform some final processes.
COPY 13-finally/ /tmp/13-finally/
RUN /tmp/13-finally/finally.sh \
  && rm -r /tmp/13-finally/

# 14
# Setup the user to use to trigger any process inside this contained.
USER ${CustomUsername}

# 15
# Default process run when nothing explicitely set.
# Notice the usage of 'sudo', to enable current user execute root's tasks, and -E, to pass
# further down all system env vars set with current user.
ENTRYPOINT exec sudo -E /opt/workmote.sh

# 16
# For any child image build on top of this, trigger processes as defined for the controller script.
# Notice the usage of 'sudo', to enable current user execute root's tasks, and -E, to pass
# further down all system env vars set with current user.
ONBUILD ENTRYPOINT exec sudo -E /usr/bin/supervisord -c /etc/supervisor/supervisord.conf