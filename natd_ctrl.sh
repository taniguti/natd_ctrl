#!/bin/sh
# Takanori TANIGUCHI
# 2012 Nov 6

while getopts "a:f:n:p:w:" flag; do
	case $flag in
		a) ADHOC_MODE="$OPTARG";;
		f) ENABLE_FW="$OPTARG";;
		n) NATD_STATE="$OPTARG";;
		p) PRIIF="$OPTARG";;
		w) WANIF="$OPTARG";;
	esac
done

# If adhoc wifi name given, create it on WiFi.
if [ ${ADHOC_MODE:-OFF} != OFF ]; then
       # Not implemented yet.
	echo "Create ADHOC WiFi: $ADHOC_MODE"
	ESSID=$ADHOC_MODE
	
fi

# WAN side Interface
WANIF=${WANID:-en2}

# Private side Interface
PRIIF=${PRIIF:-en0}

# Start natd
if [ ${NATD_STATE:-X} = "ON" ]; then
	# Enable Packet forwarding
	/usr/sbin/sysctl -w net.inet.ip.forwarding=1

	# Start natd
	/usr/sbin/natd -interface ${WANIF}

	# set rules for nat
	/sbin/ipfw -f flush
	/sbin/ipfw add divert natd all from any to any via ${WANIF}
fi

# Stop natd
if [ ${NATD_STATE:-X} = "OFF" ]; then
	# Disable Packet forwarding
	/usr/sbin/sysctl -w net.inet.ip.forwarding=0

	# kill natd
	/usr/bin/killall natd
	
	# flush rules
	/sbin/ipfw -f flush
fi

# start Firewall
# ON is OS Default config.
if [ ${ENABLE_FW:-X} = "ON" ] ; then
	/usr/sbin/sysctl -w net.inet.ip.fw.enable=1
fi

# stop Firewall
if [ ${ENABLE_FW:-X} = "OFF" ] ; then
	/usr/sbin/sysctl -w net.inet.ip.fw.enable=0
fi

# Show current state
/usr/sbin/sysctl net.inet.ip.forwarding
/usr/sbin/sysctl net.inet.ip.fw.enable
/sbin/ipfw -a l
ps aux |grep [n]atd |grep -v $0 
