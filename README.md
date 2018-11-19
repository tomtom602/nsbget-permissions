# nsbget-permissions
This is a post-processing script for nzbget on FreeBSD systems.
this script allow for user/group modification and permissions modification.
I modified the last script found at https://forum.nzbget.net/viewtopic.php?f=8&t=835#p8377
the bash directory and the parameter order for the chown function are specific to freebsd systems.

To install it, you will first need to install bash :
pkg install bash

then copy the script in your nzbget post processing script directory.

restart your nzbget 

finally set the parameters for the script in nzbget.
