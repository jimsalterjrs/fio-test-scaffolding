#!/usr/bin/perl

# Usage: fio-test.pl [read/write] [blocksize] [numjobs] [filesize] [sync]
# note that for now it's hardcoded to test in dir/pool "/test"

if (scalar @ARGV ne 5) {
	print "Usage: fio-test.pl [read/write] [blocksize] [numjobs] [filesize] [sync]\n";
	print ;
	print "Example: fio-test.pl write 4K 8 16G sync\n";
	print "         would do 4K random write on 8 processes, 16GiB, async.\n";
	exit 1;
}

# print "Clearing cache... ";

# clear caches -- ZFS will also need export/import to clear ARC
system('sync');
system('echo 3 > /proc/sys/vm/drop_caches');
sleep 1;

# variables
my $rawrw=$ARGV[0]          ; # read or write
my $rw='--rw=rand'.$ARGV[0] ; # read or write
my $rawbs=$ARGV[1]          ; # 4K or 1M
my $bs="--bs=$ARGV[1]"      ; # 4K or 1M
my $jobs=$ARGV[2]           ; # number of concurrent processes + iodepth
my $size="--size=$ARGV[3]"  ; # eg 16G
my $rawsync=$ARGV[4]           ; # sync or async

# fix up sync vs async syntax, always do end_fsync though
my $sync;
if ($rawsync eq 'sync') {
	$sync = '--fsync=1 --end_fsync=1';
} else {
	$sync = '--end_fsync=1';
}

if ($rawrw eq 'read') { $sync = ''; } # sync not applicable to read

my $fiocmd = '/usr/bin/fio';
my $directory = '--directory=/test';
my $name = '--name=fiotest';
my $ioengine = '--ioengine=posixaio';
my $numjobs = "--numjobs=$jobs --iodepth=$jobs";

# print "Beginning fio test...\n";

my $finalcmd = "$fiocmd $directory $name $rw $bs $numjobs $size $sync $ioengine --group_reporting --minimal --fallocate=none";

# allow a large enough read sample not to be contaminated with lots of ARC
# but don't loop over it if we finish EARLY (eg no --time_based)
if ($rawrw eq 'read') { $finalcmd .= " --runtime=30"; }

# debug lol
# print "$finalcmd\n";

open (FIO, "$finalcmd |");
my $rawoutput = <FIO>;
close FIO;

my @output = split(';',$rawoutput);

# perl starts counting elements at 0 lol
my $errorstatus=$output[4];
my $readbw=$output[6];
my $writebw=$output[47];
my $totalio=$output[5];

# convert KiB to MiB
$readbw = $readbw/1024;
$writebw = $writebw/1024;
$readbw = sprintf("%.2f", $readbw);
$writebw = sprintf("%.2f", $writebw);

my $outputbw;
my $testtype;
if ($rawrw eq 'read') { 
	$outputbw=$readbw ; 
	$testtype="$rawbs read";
} else { 
	$outputbw=$writebw; 
	$testtype="$rawbs $rawsync write";
}

if ($errorstatus) { die "FIO error! ='(\n"; }

print "$jobs processes/iodepth, $testtype throughput: $outputbw MiB/sec\n";

