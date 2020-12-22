#!/usr/bin/perl

use strict;

my $nconf  = $ARGV[0];
my $action = $ARGV[1];
my $node   = $ARGV[2];

my $vmhost = 'zg-vm1.thezengarden.net';

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

if ($action ne 'status')
{
  print "usage: ./cpower.pl <node config file> <poweron|poweroff|reset|status> <node|all>\n" and exit if $action eq '' or $node eq '';
}

my $maxchars = 10;

open (NODES, "< $nconf") or die "cannot open $nconf for read: #!\n";

while (my $line = <NODES>)
{
  chomp $line;
  my @n = split (/::/, $line);

  next if $n[0] =~ /^#/;

  # 122::cnode1::10.10.10.130::7E:E5:3D:C4:20:62::zg-vm1
  my $vid   = $n[0];
  my $vnode = $n[1];

  $vmhost = $n[4];

  if ($action eq 'status')
  {
    $vmcmd = `ssh $vmhost qm status $vid`;
    chomp $vmcmd;
    $vmcmd =~ s/status: //;

    my $cpad = ($maxchars - length $vnode);
    my $pad  = " " x $cpad;

    if ($vmcmd =~ /stop/)
    {
      print "${BOLD}$vnode$pad:${RESET} ${YELLOW}$vmcmd${RESET}\n";
    }
    else
    {
      print "${BOLD}$vnode$pad:${RESET} ${GREEN}$vmcmd${RESET}\n";
    }
    next;
  }

  if ($node eq $vnode)
  {
    if ($action eq 'poweron')
    {
      print "${BOLD}$vnode poweron${RESET} ...";
      $vmcmd = `ssh $vmhost qm start $vid`;
      print "${GREEN}OK!${RESET}\n";
    }
    elsif ($action eq 'poweroff')
    {
      print "${BOLD}$vnode poweroff${RESET} ...";
      $vmcmd = `ssh $vmhost qm stop $vid`;
      print "${GREEN}OK!${RESET}\n";
    }
    elsif ($action eq 'reset')
    {
      print "${BOLD}$vnode reset${RESET} ...";
      $vmcmd = `ssh $vmhost qm stop $vid`;
      sleep 2;
      $vmcmd = `ssh $vmhost qm start $vid`;
      print "${GREEN}OK!${RESET}\n";
    }
    else
    {
      print "usage: ./cpower.pl <poweron|poweroff|reset> <node|all>\n" and exit;
    }

    exit;
  }
  elsif ($node eq 'all')
  {
    if ($action eq 'poweron')
    {
      print "${BOLD}$vnode poweron${RESET} ...";
      $vmcmd = `ssh $vmhost qm start $vid`;
      print "${GREEN}OK!${RESET}\n";
    }
    elsif ($action eq 'poweroff')
    {
      print "${BOLD}$vnode poweroff${RESET} ...";
      $vmcmd = `ssh $vmhost qm stop $vid`;
      print "${GREEN}OK!${RESET}\n";
    }
    elsif ($action eq 'reset')
    {
      print "${BOLD}$vnode reset${RESET} ...";
      $vmcmd = `ssh $vmhost qm stop $vid`;
      sleep 2;
      $vmcmd = `ssh $vmhost qm start $vid`;
      print "${GREEN}OK!${RESET}\n";
    }
    else
    {
      print "usage: ./cpower.pl <poweron|poweroff|reset> <node|all>\n" and exit;
    }
  }
  else
  {
    next;
  }
}

close (NODES);
