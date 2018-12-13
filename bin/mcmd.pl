#!/usr/bin/perl

use strict;

my $nconf  = @ARGV[0];
my $ncmd   = @ARGV[1];

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

my $vmcmd;

open (NODES, "< $nconf") or die "cannot open $nconf for read: #!\n";

while (my $line = <NODES>)
{
  chomp $line;
  my @n = split (/::/, $line);

  # 122::cnode1::10.10.10.130::7E:E5:3D:C4:20:62
  my $vid   = $n[0];
  my $vnode = $n[1];
  my $vnip  = $n[2];

  $vmcmd = `ssh -T $vnode "$ncmd"`;

  print "${BOLD}$vnode${RESET}\n$vmcmd\n";
}

close (NODES);
