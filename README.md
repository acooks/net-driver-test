# net-driver-test

This is a set of scripts for testing Linux network device driver functionality.

These scripts are intended to be used with
[rapido](https://github.com/acooks/rapido/)
to test the driver in a VM.

Some advantages to this test approach include:
 * the host is protected from memory corruption errors caused by buggy kernel
   drivers;
 * the PCI peripheral can be physically installed in a multi-use machine,
   reducing hardware & lab requirements;
 * debugging info is easily available;
 * the development cycle is short and simple - rapid even :)

PCI Passthrough is required to be able to assign the real hardware peripheral
to the VM.

These tests implement the
[Kernel Test Anything Protocol (KTAP)](https://docs.kernel.org/dev-tools/ktap.html)
to format test results.


# Usage:

 1. Clone the repo
 2. Create a test script to run `start.sh`. Example below.

## Using with rapido:

    #!/usr/bin/bash

    if [[ $(id -u) -ne 0 ]]; then
            echo "Run this script as root"
            exit 1
    fi

    export NET_TEST_KMOD="tn40xx"
    export NET_TEST_SUITE="/home/acooks/net-test"
    export NET_TEST_IP_ADDR="192.168.123.4/24"
    export NET_TEST_DEV_HOST="0a:00.0"
    NET_TEST_DEV_VM="0000:00:03.0"

    START_CMD="/driver-tests/start.sh ${NET_TEST_DEV_VM} ${NET_TEST_KMOD} ${NET_TEST_IP_ADDR}"

    ./rapido cut -x "$START_CMD" net-test
