Define which packages will be installed. Certain packages require configuration, for that check
*package-defaults* build step to modify accordingly based on packages here installed

The *update-locale* file contains a list of locale values to be used in locale configs
inside the system. That file DOES NOT support comments, only valid locale entries (see locale command)
In *packages-installation.sh* file you can see the file being consumed.