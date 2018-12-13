#!/usr/bin/perl

use strict;


my $node_list     = $ARGV[0];
my $TOOL_PATH     = '/opt/cluster';
my $TFTPBOOT_PATH = '/tftpboot';
my $ROOT_PATH     = "$TFTPBOOT_PATH/clients";
my $CLIENT_DIFFS  = "$TOOL_PATH/CLIENT_DIFFS";
my $OVERLAY       = "$TOOL_PATH/OVERLAY";

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


print "usage: ./apply_diffs.pl <node list file>\n" and exit if $node_list eq '';


open (NODES, "< $node_list") or die "error: could not open $node_list for read: $!\n";

while (my $line = <NODES>)
{
  chomp $line;
  my @n = split(/::/, $line);

  print "applying ${BOLD}OVERLAY${RESET} for ${BOLD}$n[1]${RESET} at ${BOLD}$ROOT_PATH/$n[2]${RESET}";

  my $cp_overlay = `cp -a $OVERLAY/* $ROOT_PATH/$n[2]`;
  chomp $cp_overlay;
  print "$cp_overlay\n";

  print "applying ${BOLD}CLIENT DIFFS${RESET} for ${BOLD}$n[1]${RESET} at ${BOLD}$ROOT_PATH/$n[2]${RESET}";

  my $cp_diffs = `cp -a $CLIENT_DIFFS/$n[1]/* $ROOT_PATH/$n[2]`;
  chomp $cp_diffs;
  print "$cp_diffs\n";

  #print "\n\n";
}

close (NODES);

