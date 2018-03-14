# docker-base

Base image to use in Docker Envs for WorkMote.

## Description

This is the base image used to build other functionality pieces in WorkMote. All configuration
details resides in the **[build](build)** folder. Please refer to it for more details.

## About folders structure

As seen, main folder only contains data that Docker can use directly. The rest of the magic lives
in the *build* folder. There will live different folders, each of them holding scripts and data to
be used in the configuration process of things. It's recommended NOT TO PUT single files here, to
avoid cluttering the build space with several dispair file with different purposes.

## About RUN instructions

Often times a Dockerfile's information is not enough to have all correctly set when building
an image, so it's required to add/copy extra files with information on how to proceed. It was
found that relying on external scripts to do the job is better than cluttering a Dockerfile with
\ for line continuation, or escaping things here and there. That's why scripts and extra info
files are the ones used in the building process.

One thing to notice is every scripts must do only one job, for 2 things; 1) to have a clearer and
more readable file to deal with and 2) to avoid messing with Docker's caching system, as it uses
commands passed on RUN directives to invalidate cache.

## About *conf/debconf-set-selections* data

Data set in *conf/debconf-set-selections* file, has the answers to installation questions per package.
In normal systems these ones are asked every time a package in installation process
requires some configuration information.

To get answers structure, in a normal system with the required package installed, run
`debconf-get-selections` and in the output generated, search for the info about the
required package. Then, copy those answers over the *data* file, customize to your needs
and see it all working correctly.

IT'S IMPORTANT to notice this file can be used to store sensitive information as passwords
among others, so be sure to have information there as a starting point. YOU MUST NEVER, I REPEAT,
YOU MUST NEVER USE DEFAULT INFO AS SET, FOR PROVISIONED SYSTEMS.
Instead, you MUST use Docker's config and secrets functionality to pass sensitive information,
and perform package reconfigurations using new data just before program is launched, as part
of the triggering process of it. That is, starting process will have to be more complicated
than a simply start, but will require a config step and then a launch. That's the only way
to keep your data secured by using configs and/or secrets ONLY YOU KNOW!

ALSO IMPORTANT, to only use Docker's configs and/or secrets data passing for containers. AVOID
passing data in env variables (like `docker run -e ...`), generates a culture of non-security first
in favor of convenience. No bueno!

INTERESTING info on how to overcome this Secrets/Configs thing in Building process
https://elasticcompute.io/2016/01/22/build-time-secrets-with-docker-containers/
https://github.com/abourget/secrets-bridge

## About *sshd service* configuration

Some extra steps were required in order to have the service ready to be launched once a container
is run. Security was also improved by disabling root access and password only access. To access
a container, keys must be provided beforehand using Docker mechanisms.

IMPORTANT: NOTE on DEPRECATED!
Originally the image was conceived to run a ssh-agent, so it can store ssh-keys that,
in some way, would be used by the container. That proved to be a nice challenge, in
particular for keys with passphrase, but in the end it was a bad idea, as ssh-agent
running remotely, well, is clearly a bad idea because if server gets compromised, our ssh
agent too and with it, accesses we can control.

More here:
https://serverfault.com/a/672386

To use local host agent on containers (or any remote), use "ssh -A"

## About *tzdata* configuration

This part of the system required an extra configuration step as the usual data consumption from
debconf prepared answers, was not enough. More info on details here https://stackoverflow.com/a/40923787

## About *locales* configuration

Locales configuration required extra steps, different from the ones used in the rest of sections of the system,
mainly because environment variables have to be set in images, and persisted. Using current approach of
doing so only by using RUN directives proved not to be enough. RUN creates a shell to run things into it
so there's no way to set image variables from inside of a script run into it.

These different configurated let us work with more common keyboards (more than ASCII as, by default, system comes
by default), and using configurations know by us (from Ecuador, so far).

https://www.cyberciti.biz/faq/how-to-set-locales-i18n-on-a-linux-unix/
https://unix.stackexchange.com/questions/153556/consequences-of-setting-up-posix-locales
https://askubuntu.com/a/582197

## About *root* access and new user account

The use of the root account to perform every task in the container it not recommended. Not because it is
unsafe, at the end of the day is a place only, in general, one person will have access too. But the thing
is, that created the false idea of using root as a normal and correct thing to do. That's simply not true.

https://www.google.com/search?q=why+is+bad+to+use+root+user+under+linux%3F

New user account created can perform root tasks by using 'sudo' but, for security reason, will only be able
to access container using ssh keys, created and deployed on container running process, by using Docker's config
and secrets mechanisms.

Also, this new user is the one in charge of starting any process inside the container, by just simply prepend
the _sudo_ keyword.

https://stackoverflow.com/a/48329093
http://www.yegor256.com/2014/08/29/docker-non-root.html

## About *sudo* package

The *sudo* package is installed to let the newly created user perform admin tasks without having to use the
root account. However, in the Docker documentation the use of sudo is discouraged due to some signaling problems
that could appear.

https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user

Option presented was to use *gosu* (https://github.com/tianon/gosu), but in turn, that presented a warning, here
https://github.com/tianon/gosu#warning. There's and explanation in link displayed there (here https://github.com/tianon/gosu/issues/37),
about why gosu is risky (basically its usage in any interactive shell can be risky).

Solution, go back to *sudo* and use it, despite the warning messages when installed.

## About read only and tmpfs accesses

Docker compose file enforces the read-only approach in cointainers, while leaving open
access to tmpfs defined point and, of course, to volumes (read only can not prevent writings
there). Here are the reasons for such configuration and general info:
https://www.projectatomic.io/blog/2015/12/making-docker-images-write-only-in-production/
https://rehansaeed.com/docker-read-file-systems/

## About network model connection

The network connection model defined in compose file is such that it connects to the bridge
Docker daemon already offers. When that is not set, docker compose will create a new bridge
network, with it's iptables and stuff to offer container's connectivity. However, that doesn't
allow incoming traffic, for instance from host, other than ICMP and things like that
(more here https://docs.docker.com/network/).

By defining network_mode: "bridge", that tells the container's network to simply connect to
Docker daemon bridge in host. This allows incoming host traffic, and truly make this appear as
a VM to the host. For this setting to be set, there's no need to define top-level
'network' entries, as we are simply connecting to the existing bridge Docker already has.

Top-Level netowork entries are required when more customized network accesses are required.

**IMPORTANT** to notice, is network not simply creates the interfaces and communication between
them, but also set connection rules like iptables. This is really important when an isolated
environment is required, an thinking in offering network: "none" plus custom network interfaces
and bridges work will be enough. There's more things happening in back so, try to stick to
Docker's network model and customize it from it.


## TODOs
* A Warning is still displayed on 'apt-get update' because apt-utils was not found.
  It's like a chicken-egg problem, system wants the package before installing it, or some sort of thing like that.

* Currently supervisor is used as the base to start any process. However this probably is not
  good enough as there's no way to send signal to independent process from Docker's host. Two options,
  ensure supervisor is, somehow, aware of howt to pass signals or change the method to use something else
  than supervisor

* Halt process on scripts execution errors, when running under RUN command

* It was noticed the ssh service wasn't able to run at all, with a message "Missing privilege separation directory: /run/sshd"
  What was found is when the service is started for the first time, it does some things that will remove problems, 
  so, to avoid that, service is explicitely started and stopped in packages-installation build process. It's a
  workaround but works, however a more stable way of doing things is highly required.

* Move scripts to use a *Go* approach??? Possible reasons, 1) avoid the overhead on subshells utilization
  under methods used here (libashe in particular), 2) simplicity?, 3) learn a new language. Against, 1) there's
  no clear way to use shebangs on go scripts, 2) bash is ubiquitous

* Use *cloud-init* methods to configure images.

* Snapd is not Docker friendly yet, so snaps as not installed/configured in the traditional snap-way. That had to be severely
  treated in custom scripts to have them correctly set. That added to the fact that snaps stores are still reluctant to publish
  ***classic*** like packages without a manual review, made that event harder to obtain such packages from store. That's why
  packages are provided directly in config files whenever pulling from store proved to be "complicated".

  Current treatment to put snaps at work is very limited, and supports counted scenarios for different snaps.
  ***ATM***, it's necessary to test every new snap added to verify it can do its work correctly.

* ***githooks*** solution is provided, but is not working properly yet. See its repo for details.

* Current docker-compose file disables apparmor confinement to enable fuse mounts inside the cointainer. Improve
  this approach by instead of removing apparmor protection, load a less strict profile
  More info here:
  https://docs.docker.com/engine/security/apparmor/
  https://wiki.ubuntu.com/AppArmor
  https://github.com/genuinetools/bane
  https://cloud.google.com/container-optimized-os/docs/how-to/secure-apparmor
  https://medium.com/lucjuggery/docker-selinux-30-000-foot-view-30f6ef7f621