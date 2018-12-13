#!/usr/bin/perl

use strict;


my $node_list     = $ARGV[0];
my $TOOL_PATH     = '/opt/cluster';
my $TFTPBOOT_PATH = '/tftpboot';
my $ROOT_PATH     = "$TFTPBOOT_PATH/clients";
my $pkgs          = `cat $TOOL_PATH/conf/standard.pkgs`;

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


chomp $pkgs;

print "usage: ./install_standard_pkgs.pl <node list file>\n" and exit if $node_list eq '' or $pkgs eq '';


open (NODES, "< $node_list") or die "error: could not open $node_list for read: $!\n";

print "${BOLD}installing${RESET} [ ${YELLOW}$pkgs${RESET} ] for the cluster:\n";

while (my $line = <NODES>)
{
  chomp $line;
  my @n = split(/::/, $line);

  print "    $n[1] ...";

  my $install_pkg = `yum install -y $pkgs --installroot=$ROOT_PATH/$n[2]`;

  print "${GREEN}done!${RESET}\n";
}

close (NODES);

print "\n";
