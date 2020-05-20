watch -n 1 'dmesg | tail ; echo ; ls -l /dev/disk/by-id | grep ST12 | grep -v part ; echo ; d=`ls -l /dev/disk/by-id | grep ST12 | grep -v part | wc -l` ; echo \ $d disks'
