#!/usr/bin/perl

use strict;

my $client_ip = $ARGV[0];

print "usage: ./create_roote <client_ip>\n" and exit if $client_ip eq '';

print "setting up root for $client_ip...\n";

my $install_base = `yum groups install -y "Minimal Install" --releasever=7 --installroot=/tftpboot/clients/$client_ip`;
