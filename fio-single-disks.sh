#!/bin/sh

# full tests in order for pool of 8,7,6,5,4,3,2,1 single-disk vdevs
ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 8 | xargs zpool create -oashift=12 test 
./fio-8x-only.pl
zpool destroy test

ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 7 | xargs zpool create -oashift=12 test 
./fio-8x-only.pl
zpool destroy test

ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 6 | xargs zpool create -oashift=12 test 
./fio-8x-only.pl
zpool destroy test

ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 5 | xargs zpool create -oashift=12 test 
./fio-8x-only.pl
zpool destroy test

ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 4 | xargs zpool create -oashift=12 test 
./fio-8x-only.pl
zpool destroy test

ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 3 | xargs zpool create -oashift=12 test 
./fio-8x-only.pl
zpool destroy test

ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 2 | xargs zpool create -oashift=12 test 
./fio-8x-only.pl
zpool destroy test

ls /dev/disk/by-id | grep ST12 | grep -v part | head -n 1 | xargs zpool create -oashift=12 test 
./fio-8x-only.pl
zpool destroy test

