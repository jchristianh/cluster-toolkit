#!/usr/bin/perl

use strict;


my $node_list=$ARGV[0];

print "usage: ./gen_pxe <node list file>\n" and exit if $node_list eq '';

my $BOOT_NODE     = '10.10.10.129';
my $BOOT_WAIT     = 15;
my $TFTPBOOT_PATH = '/tftpboot';
my $TFTP_PXECFG   = "$TFTPBOOT_PATH/pxelinux.cfg";
my $DHCPD_CONF    = '/etc/dhcp/dhcpd.conf';
my $DHCPD_HDR     = '../etc/dhcpd_hdr.tmpl';
my $DHCPD_FTR     = '../etc/dhcpd_ftr.tmpl';

my $BOOT_REL      = `uname -r`;
chomp $BOOT_REL;

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


my $print_dhcpd_hdr = `cat $DHCPD_HDR > $DHCPD_CONF`;

open (NODES, "< $node_list") or die "error: could not open $node_list for read: $!\n";

while (my $line = <NODES>)
{
  chomp $line;
  my @n = split(/::/, $line);

  print uc("[$n[1]]\n");

  my $ip_to_hex = uc(unpack('H*', pack('C*', split('\.', $n[2]))));

  #print "  host: $n[1]\n";
  print "  ip:   $n[2]\n";
  print "  mac:  $n[3]\n\n";

  print "  generating configs:\n";
  print "  -------------------\n";
  print "  $TFTP_PXECFG/$ip_to_hex";

  open (PXECFG, "> $TFTP_PXECFG/$ip_to_hex") or die "error: could not open $TFTP_PXECFG/$ip_to_hex for write: #!\n";
  print PXECFG <<EOM;
DEFAULT linux
PROMPT 1
TIMEOUT $BOOT_WAIT

label linux
  kernel vmlinuz-$BOOT_REL
  append initrd=initrd-$BOOT_REL-netboot.img root=nfs:$BOOT_NODE:/tftpboot/clients/$n[2]:rw net-dev=eth0 nompath nodmraid net.ifnames=0 biosdevname=0 console=tty0 console=ttyS1,115200 selinux=0 pci=nommconf
EOM

  close (PXECFG);

  print "  ...done!\n";

  print "  $DHCPD_CONF";
  open (DHCPD, ">> $DHCPD_CONF") or die "error: could not open $DHCPD_CONF for append: #!\n";
  print DHCPD <<EOM;
  host $n[1] {
    hardware ethernet $n[3];
    fixed-address $n[2];
  }

EOM

  print "  ...done!\n\n\n";
}

close (NODES);

my $print_dhcpd_ftr = `cat $DHCPD_FTR >> $DHCPD_CONF`;

my $dhcpd_restart = `systemctl restart dhcpd`;
