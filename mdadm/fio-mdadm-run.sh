#!/bin/sh

echo "single disk, ext4"
	umount /test
	mdadm --stop /dev/md1
	DISK=`ls /dev/disk/by-id | grep ST1200 | grep part1 | head -n 1 | sed 's#^#/dev/disk/by-id/#'`
	wipefs -a $DISK
	mkfs.ext4 -E lazy_table_init=0, lazy_journal_init=0 $DISK
	mount $DISK /test
	echo "Device /test is single-disk ext4 $DISK"
	echo 
	./fio-mdadm-full-test.pl

echo "mdraid10, internal bitmap, ext4"

	# mdraid"10" 2 disks is just mdraid1 2 disks
	./mdraidbuild.sh 1 2 internal
	mkfs.ext4 -E lazy_table_init=0,lazy_journal_init=0 /dev/md1
	mount /dev/md1 /test
	./fio-mdadm-full-test.pl

	for disks in 4 6 8
	do
	  ./mdraidbuild.sh 10 $disks internal
	  mkfs.ext4 -E lazy_table_init=0,lazy_journal_init=0 /dev/md1
	  mount /dev/md1 /test
	  ./fio-mdadm-full-test.pl
	done

echo "mdraid6, internal bitmap, ext4"

	# mdraid"6" 3 disks is just mdraid5 3 disks
	./mdraidbuild.sh 5 3 internal
	mkfs.ext4 -E lazy_table_init=0,lazy_journal_init=0 /dev/md1
	mount /dev/md1 /test
	./fio-mdadm-full-test.pl

	for disks in 4 5 6 7 8
	do
	  ./mdraidbuild.sh 6 $disks internal
	  mkfs.ext4 -E lazy_table_init=0,lazy_journal_init=0 /dev/md1
	  mount /dev/md1 /test
	  ./fio-mdadm-full-test.pl
	done

echo "mdraid10, no bitmap, ext4"

	# mdraid"10" 2 disks is just mdraid1 2 disks
	./mdraidbuild.sh 1 2 none
	mkfs.ext4 -E lazy_table_init=0,lazy_journal_init=0 /dev/md1
	mount /dev/md1 /test
	./fio-mdadm-full-test.pl

	for disks in 4 6 8
	do
	  ./mdraidbuild.sh 10 $disks none
	  mkfs.ext4 -E lazy_table_init=0,lazy_journal_init=0 /dev/md1
	  mount /dev/md1 /test
	  ./fio-mdadm-full-test.pl
	done

echo "mdraid6, no bitmap, ext4"

	# mdraid"6" 3 disks is just mdraid5 3 disks
	./mdraidbuild.sh 5 3 none
	mkfs.ext4 -E lazy_table_init=0,lazy_journal_init=0 /dev/md1
	mount /dev/md1 /test
	./fio-mdadm-full-test.pl

	for disks in 4 5 6 7 8
	do
	  ./mdraidbuild.sh 6 $disks none
	  mkfs.ext4 -E lazy_table_init=0,lazy_journal_init=0 /dev/md1
	  mount /dev/md1 /test
	  ./fio-mdadm-full-test.pl
	done

echo "single disk, xfs"
	umount /test
	mdadm --stop /dev/md1
	DISK=`ls /dev/disk/by-id | grep ST1200 | grep part1 | head -n 1 | sed 's#^#/dev/disk/by-id/#'`
	wipefs -a $DISK
	mkfs.xfs $DISK
	mount $DISK /test
	echo "Device /test is single-disk xfs $DISK"
	echo 
	./fio-mdadm-full-test.pl


echo "mdraid10, no bitmap, xfs"
	# mdraid"10" 2 disks is just mdraid1 2 disks
	./mdraidbuild.sh 1 2 none
	wipefs -a /dev/md1
	mkfs.xfs /dev/md1
	mount /dev/md1 /test
	./fio-mdadm-full-test.pl

	for disks in 4 6 8
	do
	  ./mdraidbuild.sh 10 $disks none
	  wipefs -a /dev/md1
	  mkfs.xfs /dev/md1
	  mount /dev/md1 /test
	  ./fio-mdadm-full-test.pl
	done

echo "mdraid6, no bitmap, xfs"

	# mdraid"6" 3 disks is just mdraid5 3 disks
	./mdraidbuild.sh 5 3 none
	wipefs -a /dev/md1
	mkfs.xfs /dev/md1
	mount /dev/md1 /test
	./fio-mdadm-full-test.pl

	for disks in 4 5 6 7 8
	do
	  ./mdraidbuild.sh 6 $disks none
	  wipefs -a /dev/md1
	  mkfs.xfs /dev/md1
	  mount /dev/md1 /test
	  ./fio-mdadm-full-test.pl
	done
