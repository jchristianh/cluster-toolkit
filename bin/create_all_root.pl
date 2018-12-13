#!/usr/bin/perl

use strict;


my $node_list     = $ARGV[0];
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


print "usage: ./create_all_root.pl <node list file>\n" and exit if $node_list eq '';

print "${BOLD}creating root filesystems...${RESET}\n";

open (NODES, "< $node_list") or die "error: could not open $node_list for read: $!\n";

while (my $line = <NODES>)
{
  chomp $line;
  my @n = split(/::/, $line);

  #print "creating root for ${BOLD}$n[1]${RESET} at ${BOLD}$ROOT_PATH/$n[2]${RESET}";
  print "    ${BOLD}$n[1]${RESET} :: ${BOLD}$ROOT_PATH/$n[2]${RESET}";

  my $create_root = `mkdir -p $ROOT_PATH/$n[2] && $TOOL_PATH/bin/create_root.sh $n[2]`;

  print "  ...${GREEN}done!${RESET}\n";
}

close (NODES);

