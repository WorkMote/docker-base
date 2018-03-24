Programs/Services to be run when the container is triggered.

BEWARE commands/scripts or anything triggered from here will be run by "root"
user (see ENTRYPOINT and ONBUILD ENTRYPOINT) in Dockerfile, so pay attention commands
executed are available to "root". Found problems when dealing with snap packages
as those run from a different place.