# Usage: mdraidbuild.sh raidlevel numdisks
#
# Result: builds an mdraid array of $raidlevel and $numdisks
#
# WARNING WARNING WARNING WARNING WARNING
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
#
# This script assumes that all Seagate 12TB disks present are test disks.
# DO NOT RUN IF USING 12TB SEAGATE DRIVES IN PRODUCTION!
#
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# WARNING WARNING WARNING WARNING WARNING

if [ $# -ne 2 ]
  then
    echo "This script needs two arguments: RAID level, and number of disks."
    echo
    echo "WARNING: this script assumes all Seagate 12TB disks it can find"
    echo "are test disks, and will do VERY DESTRUCTIVE THINGS to them!"
    echo "DO NOT RUN THIS SCRIPT on a system with production Seagate 12TB disks!"
    echo
    exit 1
fi

LEVEL=$1
NUM=$2

# tear down any test pool or mdraid array.
umount /test
mdadm --stop /dev/md1
zpool export test

# get rid of any mdraid or ZFS headers on part1 of all test disks
for disk in `ls /dev/disk/by-id | grep ST1200 | grep part1 | sed 's#^#/dev/disk/by-id/#'`; do wipefs -a $disk; done

# build array RAID$LEVEL of $NUM test disks
ls /dev/disk/by-id | grep ST1200 | grep part1 | head -n$NUM | sed 's#^#/dev/disk/by-id/#' | xargs mdadm --create /dev/md1 --assume-clean -b none -l$LEVEL -n$NUM

# output status of /dev/md1
mdadm --detail /dev/md1
