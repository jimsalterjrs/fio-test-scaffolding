#!/bin/sh

# full tests in order for pool of 4,3,2,1 2n mirror vdevs
ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 2 | tail -n 2 | xargs zpool create -oashift=12 test mirror
ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 4 | tail -n 2 | xargs zpool add -oashift=12 test mirror
ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 6 | tail -n 2 | xargs zpool add -oashift=12 test mirror
ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 8 | tail -n 2 | xargs zpool add -oashift=12 test mirror
zfs set recordsize=1m test
./fio-full-test.pl
zpool destroy test

ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 2 | tail -n 2 | xargs zpool create -oashift=12 test mirror
ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 4 | tail -n 2 | xargs zpool add -oashift=12 test mirror
ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 6 | tail -n 2 | xargs zpool add -oashift=12 test mirror
zfs set recordsize=1m test
./fio-full-test.pl
zpool destroy test

ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 2 | tail -n 2 | xargs zpool create -oashift=12 test mirror
ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 4 | tail -n 2 | xargs zpool add -oashift=12 test mirror
zfs set recordsize=1m test
./fio-full-test.pl
zpool destroy test

# full test for 2x RAIDz2 4n vdevs
ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 4 | xargs zpool create -oashift=12 test raidz2
ls /dev/disk/by-id | grep ST12 | grep -v part | tail -n 4 | xargs zpool add -oashift=12 test raidz2
zfs set recordsize=1m test
./fio-full-test.pl
zpool destroy test

# full tests in order for 1x RAIDz2 8n,7n,6n,5n,4n and 1x RAIDz1 3n
ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 8 | xargs zpool create -oashift=12 test raidz2
zfs set recordsize=1m test
./fio-full-test.pl
zpool destroy test

ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 7 | xargs zpool create -oashift=12 test raidz2
zfs set recordsize=1m test
./fio-full-test.pl
zpool destroy test

ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 6 | xargs zpool create -oashift=12 test raidz2
zfs set recordsize=1m test
./fio-full-test.pl
zpool destroy test

ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 5 | xargs zpool create -oashift=12 test raidz2
zfs set recordsize=1m test
./fio-full-test.pl
zpool destroy test

ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 4 | xargs zpool create -oashift=12 test raidz2
zfs set recordsize=1m test
./fio-full-test.pl
zpool destroy test

ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 3 | xargs zpool create -oashift=12 test raidz1
zfs set recordsize=1m test
./fio-full-test.pl
zpool destroy test

# full test for single disk
ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 1 | xargs zpool create -oashift=12 test
zfs set recordsize=1m test
./fio-full-test.pl
zpool destroy test

