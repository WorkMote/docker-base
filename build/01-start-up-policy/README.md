It's not desirable that services start as soon as they got installed (http://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/),
that's why a policy.rc-d file needs to be setup.
This was originally intended for Upstart system service, but works with current systemd systems.

