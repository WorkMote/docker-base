Deals with the process of enabling snap packages under a Docker environment. So far,
that is not supported and/or requires a lot of configurations.

There are other problems too, as for some snap packages, a special ***classic*** confinement
is required, and getting that is a horrible and slow process, so you can not simply publish
a package like that. That's why, when possible, packages are passed here.

Current treatment to put snaps at work is very limited, and supports counted scenarios for different
snaps.

RULE OF THUMB: Test every new snap added beforehand.