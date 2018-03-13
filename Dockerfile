FROM ubuntu:17.10

# Version number for Local development environment for Bluetent client as Workmote.
LABEL com.workmote.bluetent.local.version="0.1"
# Purpose of anything here installed for Local development environment for Bluetent client as Workmote.
LABEL com.workmote.bluetent.local.purpose="base"
# Application name here installed for Local development environment for Bluetent client as Workmote.
LABEL com.workmote.bluetent.local.app="base"

# To avoid having errors like "unable to initialize frontend: Dialog" when packages
# are upgraded/installed.
ARG DEBIAN_FRONTEND=noninteractive

# 00
# Prompt setup process.
COPY build/00-prompt-setup/ /tmp/00-prompt-setup/
RUN /tmp/00-prompt-setup/prompt-setup.sh \
  && rm -r /tmp/00-prompt-setup/

# 01
# Start up processes after installation policy
COPY build/01-start-up-policy/ /tmp/01-start-up-policy/
RUN /tmp/01-start-up-policy/start-up-policy.sh \
  && rm -r /tmp/01-start-up-policy/

# 02
# Load debconf selections for packages to be installed.
COPY build/02-packages-defaults/ /tmp/02-packages-defaults/
RUN /tmp/02-packages-defaults/packages-defaults.sh \
	&& rm -r /tmp/02-packages-defaults/

# 03
# System upgrade.
COPY build/03-system-upgrade/ /tmp/03-system-upgrade/
RUN /tmp/03-system-upgrade/system-upgrade.sh \
  && rm -r /tmp/03-system-upgrade/

# 04
# Packages installation.
COPY build/04-packages-installation/ /tmp/04-packages-installation/
RUN /tmp/04-packages-installation/packages-installation.sh \
  && rm -r /tmp/04-packages-installation/

# 05
# ssh/sshd configuration.
COPY build/05-ssh-sshd-configuration/ /tmp/05-ssh-sshd-configuration/
RUN /tmp/05-ssh-sshd-configuration/ssh-sshd-configuration.sh \
  && rm -r /tmp/05-ssh-sshd-configuration/

# 06
# tzdata configuration.
COPY build/06-tzdata-configuration/ /tmp/06-tzdata-configuration/
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
# Custom user configuration.
COPY build/08-custom-user/ /tmp/08-custom-user/
RUN /tmp/08-custom-user/custom-user.sh \
  && rm -r /tmp/08-custom-user/

# 09
# snap packages configuration.
COPY build/09-snap-packages/ /tmp/09-snap-packages/
RUN /tmp/09-snap-packages/snap-packages.sh \
  && rm -r /tmp/09-snap-packages/
ENV PATH="${PATH}:/snap/bin"

# 10
# Set the external volume mount place, to be filled with any data meant to be persisted
# when the container is running.
VOLUME /data/

# 11
# Setup the default welcome message process.
COPY build/11-welcome/workmote.sh /opt/

# 12
# Set the main processes for supervisor to run. The reason of containers using this image.
COPY build/12-supervisor/ /etc/supervisor/conf.d/

# 13
# Setup the user to use to trigger any process inside this contained.
USER workmote

# 14
# Default process run when nothing explicitely set.
# Notice the usage of 'sudo', to enable current user execute root's tasks.
ENTRYPOINT exec sudo /opt/workmote.sh

# 15
# For any child image build on top of this, trigger processes as defined for the controller script.
# Notice the usage of 'sudo', to enable current user execute root's tasks.
ONBUILD ENTRYPOINT exec sudo /usr/bin/supervisord -c /etc/supervisor/supervisord.conf