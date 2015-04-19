#!/usr/bin/awk -f

BEGIN {
  # It is not possible to define output file names here because
  # FILENAME is not define in the BEGIN section
  n = "";
  printf "Generating data files ...";
  network_max_bandwidth_in_byte = 10000000;
  network_max_packet_per_second = 1000000;
  last3 = 0;
  last4 = 0;
  last5 = 0;
  last6 = 0;
}
{
  print $2"1:"NR
  if ($2 ~ /Average/)
    { # Skip the Average values
      n = "";
      next;
    }

  print $3"2:"NR
  if ($3 ~ /all/)
    { # This is the cpu info
      print $4 > FILENAME".cpu.user.dat";
#	  print $4 > FILENAME".cpu.nice.dat";
      print $6 > FILENAME".cpu.system.dat";
      print $7 > FILENAME".cpu.iowait.dat";
      print $9 > FILENAME".cpu.idle.dat";
      print 100-$9 > FILENAME".cpu.busy.dat";
    }
  #if ($3 ~ /eth0/)
#  if ($3 ~ /IFACE/)
#    { # This is the eth0 network info
#      if ($4 > network_max_packet_per_second)
#	print last3 > FILENAME".net.rxpck.dat"; # Total number of packets received per second.
#      else
#	{
#	  last3 = $4;
#	  print $4 > FILENAME".net.rxpck.dat"; # Total number of packets received per second.
#	}
#      if ($5 > network_max_packet_per_second)
#	print last4 > FILENAME".net.txpck.dat"; # Total number of packets transmitted per second.
#      else
#	{
#	  last4 = $5;
#	  print $5 > FILENAME".net.txpck.dat"; # Total number of packets transmitted per second.
#	}
#      if ($6 > network_max_bandwidth_in_byte)
#	print last5 > FILENAME".net.rxbyt.dat"; # Total number of bytes received per second.
#      else
#	{
#	  last5 = $6;
#	  print $6 > FILENAME".net.rxbyt.dat"; # Total number of bytes received per second.
#	}
#      if ($7 > network_max_bandwidth_in_byte)
#	print last6 > FILENAME".net.txbyt.dat"; # Total number of bytes transmitted per second.
#      else
#	{
#	  last6 = $7;
#	  print $7 > FILENAME".net.txbyt.dat"; # Total number of bytes transmitted per second.
#	}
##     print $7 > FILENAME".net.rxcmp.dat"; # Number of compressed packets received per second (for cslip etc.).
##     print $8 > FILENAME".net.txcmp.dat"; # Number of compressed packets transmitted per second.
##     print $9 > FILENAME".net.rxmcst.dat"; # Number of multicast packets received per second.
#    }


  # Detect network devices
  if ($3 ~ /lo|eth0|eth1|br0|virbr0|virbr0-nic|docker0/)
  {
	n=$3;
        print $4 > FILENAME"."n".net.rxpck.dat"; # Total number of packets received per second.
        print $5 > FILENAME"."n".net.txpck.dat"; # Total number of packets transmitted per second.
        print $6 > FILENAME"."n".net.rxkb.dat"; # Total number of kilobytes received per second.
	print $7 > FILENAME"."n".net.txkb.dat"; # Total number of kilobytes transmitted per second.
	print $8 > FILENAME"."n".net.rxcmp.dat"; # Total number of compressed packets received per second.
	print $9 > FILENAME"."n".net.txcmp.dat"; # Total number of compressed packets transmitted per second.
	print $10 > FILENAME"."n".net.rxmcst.dat"; # Total number of multicast packets received per second.
   }
  
  # Detect which is the next info to be parsed
  if ($3 ~ /proc|cswch|tps|kbmemfree|totsck/)
    {
      n = $3;
    }

  # Only get lines with numbers (real data !)
  if ($3 ~ /[0-9]/)
    {
      if (n == "proc/s")
	{ # This is the proc/s info
	  print $3 > FILENAME".proc.dat";
#	  n = "";
	}
      if (n == "cswch/s")
	{ # This is the context switches per second info
	  print $3 > FILENAME".ctxsw.dat";
#	  n = "";
	}
      if (n == "tps")
	{ # This is the disk info
	  print $3 > FILENAME".disk.tps.dat"; # total transfers per second
	  print $4 > FILENAME".disk.rtps.dat"; # read requests per second
	  print $5 > FILENAME".disk.wtps.dat"; # write requests per second
	  print $6 > FILENAME".disk.brdps.dat"; # block reads per second
	  print $7 > FILENAME".disk.bwrps.dat"; # block writes per second
#	  n = "";
	}
      if (n == "kbmemfree")
	{ # This is the mem info
	  print $3 > FILENAME".mem.kbmemfree.dat"; # Amount of free memory available in kilobytes.
	  print $4 > FILENAME".mem.kbmemused.dat"; # Amount of used memory in kilobytes. This does not take into account memory used by the kernel itself.
	  print $5 > FILENAME".mem.memused.dat"; # Percentage of used memory.
#         It appears the kbmemshrd has been removed from the sysstat output - ntolia
#	  print $X > FILENAME".mem.kbmemshrd.dat"; # Amount of memory shared by the system in kilobytes.  Always zero with 2.4 kernels.
	  print $6 > FILENAME".mem.kbbuffers.dat"; # Amount of memory used as buffers by the kernel in kilobytes.
	  print $7 > FILENAME".mem.kbcached.dat"; # Amount of memory used to cache data by the kernel in kilobytes.
	  print $8 > FILENAME".mem.kbcommit.dat"; # Amount of memory committed in kilobytes
	  print $9 > FILENAME".mem.commit.dat"; # Percentage of memory committed
#	  print $7 > FILENAME".mem.kbswpfree.dat"; # Amount of free swap space in kilobytes.
#	  print $8 > FILENAME".mem.kbswpused.dat"; # Amount of used swap space in kilobytes.
	  #print $10 > FILENAME".mem.swpused.dat"; # Percentage of used swap space.
#	  n = "";
 	}
      if (n == "totsck")
	{ # This is the socket info
	  print $3 > FILENAME".sock.totsck.dat"; # Total number of used sockets.
	  print $4 > FILENAME".sock.tcpsck.dat"; # Number of TCP sockets currently in use.
#	  print $4 > FILENAME".sock.udpsck.dat"; # Number of UDP sockets currently in use.
#	  print $5 > FILENAME".sock.rawsck.dat"; # Number of RAW sockets currently in use.
#	  print $6 > FILENAME".sock.ip-frag.dat"; # Number of IP fragments currently in use.
#	  n = "";
 	}
    }
}
END {
  print " '" FILENAME "' done.";
}
