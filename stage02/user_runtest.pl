#!/usr/bin/perl

open (STDERR, ">&STDOUT");

$ec2timeout = 20;
$mode = shift @ARGV;

if( $mode eq "" ){
        my $this_mode = `cat ../input/2b_tested.lst | grep NETWORK`;
        chomp($this_mode);
        if( $this_mode =~ /^NETWORK\s+(\S+)/ ){
                $mode = lc($1);
        };
};

print "Mode:\t$mode \n\n";

if ($mode eq "system" || $mode eq "static") {
    $managed = 0;
} else {
    $managed = 1;
}

print "Ignoring the Mode \n\n";
$managed = 0;

# get the emis
system("date");
$cmd = "runat $ec2timeout euca-describe-images -a | grep -v ebs | grep -v deregister";
$count=0;
open(RFH, "$cmd|");
while(<RFH>) {
    chomp;
    my $line = $_;
    my ($type, $id, @tmp) = split(/\s+/, $line);
    if ($id =~ /^emi/) {
	$emis[$count] = $id;
	$count++;
    }
}
close(RFH);
if (@emis < 1) {
    print "ERROR: could not get emis from euca-describe-images\n";
    exit(1);
}

#choose one at random
$theemi = $emis[int(rand(@emis))];

#choose number to run
#$numinsts = int(rand(2)) + 1;    
$numinsts=1;

#choose ssh key
$count=0;
system("date");
$cmd = "runat $ec2timeout euca-describe-keypairs";
open(RFH, "$cmd|");
while(<RFH>) {
    chomp;
    my $line = $_;
    my ($tmp, $kp) = split(/\s+/, $line);
    if ($kp) {
	$kps[$count] = $kp;
	$count++;
    }
}
close(RFH);
if (@kps < 1) {
    print "ERROR: could not get keypairs from euca-describe-keypairs\n";
    exit(1);
}
$kp = $kps[int(rand(@kps))];
$thekey = "$kp";

if ($managed) {
#choose public address
$count=0;
system("date");
$cmd = "runat $ec2timeout euca-describe-addresses | grep admin";
open(RFH, "$cmd|");
while(<RFH>) {
    chomp;
    my $line = $_;
    my ($tmp, $ip) = split(/\s+/, $line);
    if ($ip) {
	$ips[$count] = $ip;
	$count++;
    }
}
close(RFH);
if (@ips < 1) {
    print "ERROR: could not get addrs from euca-describe-addresses\n";
    exit(1);
}
#choose ip at random
$theip = $ips[int(rand(@ips))];
} else {
    
}

#choose public address
$count=0;
system("date");
$cmd = "runat $ec2timeout euca-describe-groups";
open(RFH, "$cmd|");
while(<RFH>) {
    chomp;
    my $line = $_;
    my ($type, $meh, $group) = split(/\s+/, $line);
    if ($type eq "GROUP") {
	if ($group && $group ne "default") {
	    $groups[$count] = $group;
	    $count++;
	}
    }
}
close(RFH);
if (@groups < 1) {
    print "ERROR: could not get groups from euca-describe-groups\n";
    exit(1);
}
#choose group at random
$thegroup = $groups[int(rand(@groups))];
#$thegroup = "default";
print "EMI:$theemi KEY:$thekey GROUP:$thegroup NUMINST:$numinsts\n";

#ready to run

$done=$runcount=0;
while(!$done && $runcount < 10) {
    system("date");
$cmd = "runat $ec2timeout euca-run-instances $theemi -k $thekey -n $numinsts -g $thegroup";
    $count=0;
    open(RFH, "$cmd|");
    while(<RFH>) {
	chomp;
	my $line = $_;
	print "OUTPUT: $line\n";
	my ($type, $id, @tmp) = split(/\s+/, $line);
	if ($type eq "INSTANCE") {
	    $ids[$count] = $id;
	    $count++;
	}
    }
    close(RFH);
    $runcount++;
    $numrunnin = @ids;
    print "STARTED:@ids, $numrunnin, $numinsts\n";
    if ($numrunnin != $numinsts) {
	$n = @ids;
	print "not enough resources yet (or timeout), retrying\n";
    } else {
	$done++;
    }
}

if (!$done) {
    print "ERROR: could not start target number of insts (target/actual): $numinsts/@n\n";
    exit(1);
}
exit(0);

