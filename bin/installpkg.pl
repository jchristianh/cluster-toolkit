#!/usr/bin/perl

use strict;


my $node_list     = $ARGV[0];
my $pkgs          = $ARGV[1];
my $TOOL_PATH     = '/opt/cluster';
my $TFTPBOOT_PATH = '/tftpboot';
my $ROOT_PATH     = "$TFTPBOOT_PATH/clients";

my %clrs = (
  'red'    => "\033[1;31m",
  'yellow' => "\033[1;33m",
  'green'  => "\033[1;32m",
  'bold'   => "\033[1m",
  'reset'  => "\033[0m"
);

my $RED    = $clrs{red};
my $YELLOW = $clrs{yellow};
my $GREEN  = $clrs{green};
my $BOLD   = $clrs{bold};
my $RESET  = $clrs{reset};


print "usage: ./installpkg.pl <node list file> <pkg(s)>\n" and exit if $node_list eq '' or $pkgs eq '';


open (NODES, "< $node_list") or die "error: could not open $node_list for read: $!\n";

while (my $line = <NODES>)
{
  chomp $line;
  my @n = split(/::/, $line);

  print "installing $pkgs for $n[1] at $ROOT_PATH/$n[2]";

  my $install_pkg = `yum install -y $pkgs --installroot=$ROOT_PATH/$n[2]`;

  print "  ...done!\n\n";
}

close (NODES);

