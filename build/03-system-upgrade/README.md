Update the system with latest packages.

In Docker documentation is discouraged the use of 'apt-get dist-upgrade' as, they say,
"many of the “essential” packages from the parent images can’t upgrade inside an unprivileged container".
This can be true, but it's preferable to have a secure and stable base, controlled by us, than
waiting for fixes to arrive to base image (if ever).
Anything that requires extra treatment to be ready, will have to be performed in the next run, to
avoid such scenario as Docker describes
