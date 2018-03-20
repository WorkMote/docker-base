#!/bin/bash

# Perform a general data clean up.
apt-get autoremove --purge -y
apt-get autoclean -y
apt-get clean -y
rm -rf /var/lib/apt/lists/*