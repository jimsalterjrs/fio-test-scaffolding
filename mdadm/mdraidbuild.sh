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

if [ $# -ne 3 ]
  then
    echo "This script needs three arguments: RAID level, number of disks, and bitmap (none/internal)."
    echo
    echo "WARNING: this script assumes all Seagate 12TB disks it can find"
    echo "are test disks, and will do VERY DESTRUCTIVE THINGS to them!"
    echo "DO NOT RUN THIS SCRIPT on a system with production Seagate 12TB disks!"
    echo
    exit 1
fi

LEVEL=$1
NUM=$2
BITMAP=$3

# tear down any test mdraid array (/dev/md1, /test).
umount /test
mdadm --stop /dev/md1
#zpool export test

# get rid of any mdraid or ZFS headers on part1 of all test disks
for disk in `ls /dev/disk/by-id | grep ST1200 | grep part1 | sed 's#^#/dev/disk/by-id/#'`; do wipefs -a $disk; done

# give system time to settle
sleep 5

# build array RAID$LEVEL of $NUM test disks with bitmap type $BITMAP
ls /dev/disk/by-id | grep ST1200 | grep part1 | head -n$NUM | sed 's#^#/dev/disk/by-id/#' | xargs mdadm --create /dev/md1 --assume-clean -l$LEVEL -n$NUM -b$BITMAP

# output abbreviated status of /dev/md1
mdadm --detail /dev/md1 | grep -B20 Consistency | egrep -v '(Active|Failed|Working|Spare) Devices' | grep -v "Used Dev Size" | grep -v "Total Devices" | grep -v "Update Time"
