#!/usr/bin/bash

# Iterate over a list of MTU sizes
#
# This test simply checks whether the driver reports that is has successfully
# changed the MTU. It doesn't check whether the interface can send/receive data
# after the change.
#
# This can trigger a driver bug where the device stops receiving data, but the
# test will not detect it.
#
# FIXME: the supported MTUs are hardware defined.

[[ $(type -t now) == function ]] ||
	source $(dirname ${BASH_SOURCE[0]})/include.sh

# Lets try a few MTU sizes
declare -a SUPPORTED_MTUS=(604 1279 1280 1499 1500 1520 1650 8900 9000 9100 16383)
#16384 is in which list?
declare -a UNSUPPORTED_MTUS=(500 16385)

ktap "KTAP version 1"
ktap "# walking mtu sizes: ${SUPPORTED_MTUS[@]}"
ktap "1..${#SUPPORTED_MTUS[@]}"

let N=1
for MTU in ${SUPPORTED_MTUS[@]}; do
	ktap "# Checking supported $MTU"
	ip link set dev $IFNAME mtu $MTU || fail "# Failed to set MTU $MTU"
	(ip --oneline link show dev $IFNAME | grep "mtu $MTU") &&
		ktap "ok $N MTU_$MTU" ||
		ktap "not ok $N MTU_$MTU"
	let N++
done

# Unsupported MTUs should return error
ktap "KTAP version 1"
ktap "# walking mtu sizes: ${UNSUPPORTED_MTUS[@]}"
ktap "1..${#UNSUPPORTED_MTUS[@]}"

let N=1
for MTU in ${UNSUPPORTED_MTUS[@]}; do
	ktap "# Checking unsupported $MTU"
	ip link set dev $IFNAME mtu $MTU &&
		ktap "not ok $N MTU_$MTU" ||
		ktap "ok $N MTU_$MTU"
	let N++
done

ip link set dev $IFNAME mtu 1500

ktap "# MTU walk done"
