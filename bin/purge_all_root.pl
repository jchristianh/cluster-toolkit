#!/usr/bin/perl

use strict;


my $node_list     = $ARGV[0];
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


print "usage: ./purge_all_root.pl <node list file>\n" and exit if $node_list eq '';


open (NODES, "< $node_list") or die "error: could not open $node_list for read: $!\n";

print "purging root filesystems...\n";

while (my $line = <NODES>)
{
  chomp $line;
  my @n = split(/::/, $line);

  #print "purging root for $n[1] at $ROOT_PATH/$n[2]";
  print "    ${BOLD}$n[1]${RESET} :: ${BOLD}$ROOT_PATH/$n[2]${RESET}";

  my $purge_root = `rm -rf $ROOT_PATH/$n[2]`;

  print "  ...${RED}purged!${RESET}\n";
}

close (NODES);

