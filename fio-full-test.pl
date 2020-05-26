#!/usr/bin/perl

system ('zpool','status','test');
print "\n";

#my $result=loop('write','1M','1','4M','async');

# order of tests MATTERS, because we do write tests before
# reads in such a way that the read tests don't end up doing
# their own writes. This prevents read results contaminated
# by presence of written data still in ARC.

my $result;

# # bullshit rapid test to uncomment for debugging 
# $result=loop('write','1M','1','4M','async'); print " $result\n";
# exit 0;

print "Throwaway 8x2G async write test... ";
system ('./fio-test.pl write 1M 8 2G async');
print "Throwaway 1x8G async write test... ";
system ('./fio-test.pl write 1M 1 8G async');
print "\n\n";

# actual testing section
$result=loop('write','1M','8','2G','async'); print " $result\n";
$result=loop('write','1M','8','1G','sync'); print " $result\n";
$result=loop('read','1M','8','2G','async'); print " $result\n";
print "\n";
$result=loop('write','1M','1','8G','async'); print " $result\n";
$result=loop('write','1M','1','1G','sync'); print " $result\n";
$result=loop('read','1M','1','8G','async'); print " $result\n";
print "\n";
$result=loop('write','4K','8','2G','async'); print " $result\n";
$result=loop('write','4K','8','16M','sync'); print " $result\n";
$result=loop('read','4K','8','2G','async'); print " $result\n";
print "\n";
$result=loop('write','4K','1','2G','async'); print " $result\n";
$result=loop('write','4K','1','16M','sync'); print " $result\n";
$result=loop('read','4K','1','8G','async'); print " $result\n";

exit;

##########################################333

sub testtype {
	my $rw = shift;
	my $bs = shift;
	my $procs = shift;
	my $filesize = shift;
	my $sync = shift;

	# hack to omit sync if read
	if ($rw eq 'write') {
		$rw = "$sync $rw";
	}
	my $result = $procs . 'x' . "$filesize $bs $rw:";
	return $result;
}

sub loop {
	# loop(readwrite, blocksize, number of processes, filesize, sync)
	my $rw=shift;
	my $bs=shift;
	my $procs=shift;
	my $filesize=shift;
	my $sync=shift;

	my @rawresults;
	my $testtype = testtype($rw,$bs,$procs,$filesize,$sync);

	# Give us something to look at, precious...
	print "$testtype (";

	for (my $loop=0; $loop<3; $loop++) {
		# leading comma if necessary
		if ($loop>0) { print ','; }
		print "$loop";

		# comment this out if we're not doing ZFS
		system ('zpool export test');
		system ('zpool import test');

		# give system a chance to settle. shouldn't matter, but...?
		sleep 5;

		open (FIO, "./fio-test.pl $rw $bs $procs $filesize $sync |");
		$rawresults[$loop] = <FIO>;
		#print " $rawresults[$loop]";
		close FIO;
	}

	print ')';

	my @results;
	my $avg;
	for (my $loop=0; $loop<3; $loop++) {
		my $out = $rawresults[$loop];
		$out =~ /(\d*\.?\d*) MiB\/sec/;
		$results[$loop] = $1;
		# print "$results[$loop] ";
		$avg += $results[$loop];
	}

	@results = sort @results;
	$avg = sprintf('%.2f',($avg/3));

	my $plusminus = sprintf('%.2f',(($results[2]-$results[0])/2));

	my $out = " $avg MiB/sec (+/- $plusminus)";
	return $out;
}

