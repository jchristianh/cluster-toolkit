#!/usr/bin/perl

use strict;


my $pkgs          = $ARGV[0];
my $TOOL_PATH     = '/opt/cluster';
my $IMG_PATH      = "$TOOL_PATH/STATIC_IMAGE/CENTOS7_64";


print "usage: ./installpkg.pl <pkg(s)>\n" and exit if $pkgs eq '';

print "installing $pkgs for $IMG_PATH";

my $install_pkg = `yum install -y $pkgs --installroot=$IMG_PATH`;

print "  ...done!\n\n";
