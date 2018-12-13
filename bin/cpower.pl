#!/usr/bin/perl

use strict;

my $nconf  = $ARGV[0];
my $action = $ARGV[1];
my $node   = $ARGV[2];

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

open (NODES, "< $nconf") or die "cannot open $nconf for read: #!\n";

while (my $line = <NODES>)
{
  chomp $line;
  my @n = split (/::/, $line);

  # 122::cnode1::10.10.10.130::7E:E5:3D:C4:20:62
  my $vid   = $n[0];
  my $vnode = $n[1];

  if ($action eq 'status')
  {
    $vmcmd = `ssh kaiju qm status $vid`;
    chomp $vmcmd;
    $vmcmd =~ s/status: //;
    if ($vmcmd =~ /stop/)
    {
      print "${BOLD}$vnode:${RESET} ${YELLOW}$vmcmd${RESET}\n";
    }
    else
    {
      print "${BOLD}$vnode:${RESET} ${GREEN}$vmcmd${RESET}\n";
    }
    next;
  }

  if ($node eq $vnode)
  {
    if ($action eq 'poweron')
    {
      print "${BOLD}$vnode poweron${RESET} ...";
      $vmcmd = `ssh kaiju qm start $vid`;
      print "${GREEN}OK!${RESET}\n";
    }
    elsif ($action eq 'poweroff')
    {
      print "${BOLD}$vnode poweroff${RESET} ...";
      $vmcmd = `ssh kaiju qm stop $vid`;
      print "${GREEN}OK!${RESET}\n";
    }
    elsif ($action eq 'reset')
    {
      print "${BOLD}$vnode reset${RESET} ...";
      $vmcmd = `ssh kaiju qm stop $vid`;
      sleep 2;
      $vmcmd = `ssh kaiju qm start $vid`;
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
      $vmcmd = `ssh kaiju qm start $vid`;
      print "${GREEN}OK!${RESET}\n";
    }
    elsif ($action eq 'poweroff')
    {
      print "${BOLD}$vnode poweroff${RESET} ...";
      $vmcmd = `ssh kaiju qm stop $vid`;
      print "${GREEN}OK!${RESET}\n";
    }
    elsif ($action eq 'reset')
    {
      print "${BOLD}$vnode reset${RESET} ...";
      $vmcmd = `ssh kaiju qm stop $vid`;
      sleep 2;
      $vmcmd = `ssh kaiju qm start $vid`;
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
