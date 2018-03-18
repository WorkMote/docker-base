#!/bin/bash

# Perform a general data clean up.
apt-get autoremove --purge
apt-get autoclean
apt-get clean
rm -rf /var/lib/apt/lists/*