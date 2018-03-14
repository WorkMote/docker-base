Extra configuration steps to completely configure and secure the SSH service.

NOTE on DEPRECATED!
Originally the image was conceived to run a ssh-agent, so it can store ssh-keys that,
in some way, would be used by the container. That proved to be a nice challenge, in
particular for keys with passphrase, but in the end it was a bad idea, as ssh-agent
running remotely, well, is clearly a bad idea a we have no control on data there and/or
if agent was hijacked and with it, accessses with our keys.

To use local host agent on containers (or any remote), use "ssh -A"