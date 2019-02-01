use strict;
use warnings;

my $base = 'c:/coding/perl_prog/';
my $file_name = 'result1.txt';
my %mp;
my %mp_cnt;

sub print_result {
	print_header();
	my @ks = keys %mp;
	
	foreach (@ks) {
		print $_.":\n".$mp{$_};
	}
}

sub print_header {
	my @ks = keys %mp;
	my $space_num = 12; 
	print '--------------------------SUMMARAY----------------------------'."\n";
	print "CHECK TYPE";
	print "\t" x ($space_num - (length "CHECK TYPE") / 4);
	print "COUNT\n";
	foreach (@ks) {
		my $sp_n = $space_num - ((length $_) / 4);
		if ((length $_) % 4 == 0) {
			$sp_n--;
		}
		print $_;
		print "\t" x $sp_n;
		print $mp_cnt{$_}."\n";
	}
	print '--------------------------------------------------------------'."\n";
	print "\n";
}

sub getfun {
	my ($name) = @_;
	if ($name =~ /([^\(]+)\(/) {
		$1;
	} else {
		$name;
	}
}

sub parseJava {
	my ($fb1) = @_;
	my $curr_java = '';
	my $str;
	
	open(DATA, "<$fb1") or die "Couldn't open file, $!";
	while(<DATA>) {
		if (/(.*)\t\t->\t\t(.*)/) {
			my $tmp = getfun($2);
			if ($mp{$tmp} && $mp{$tmp} ne '') {
				$mp{$tmp} = $mp{$tmp}."\t".$1."\n";
				$mp_cnt{$tmp} = $mp_cnt{$tmp} + 1;
			} else {
				$mp{$tmp} = "\t".$1."\n";
				$mp_cnt{$tmp} = 1;
			}
			
			next;
		}
		
	}
	
	close(DATA);
	1;
}

parseJava ($base.$file_name);
print_result();