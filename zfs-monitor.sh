watch -n 1 'zpool iostat test -y -v 1 1 ; echo ; ls -l /dev/disk/by-id | grep ST1200 | grep -v part | awk "{print \$11}" | sed "s#../../#/dev/#" | xargs iostat --human -xy 1 1 /dev/md1'
