use strict;
use warnings;

my $f_src = 'file_lib.txt';
my $to_chk = 'to_check.txt';
my %loc_map;
my @match_list;
my $count = 0;

open(DATA, "<$f_src") or die "Couldn't open file file.txt, $!";
my $tmp_h = '';
my $loc = '';
while(<DATA>) {
	if (/^(\/\S+)\s+(.*)/) {
		$tmp_h = $1;
		$loc = $2;
	} elsif (/^\s+(\S+)/) {
		$loc_map{"$tmp_h$1"} = $loc;
	}
}
close(DATA);

open(DATA, "<$to_chk") or die "Couldn't open file file.txt, $!";
while(<DATA>) {
	if (/([^\n]+)/) {
		push @match_list, $1;
	}
}
close(DATA);

#print scalar @match_list;
foreach(@match_list) {
	$loc = $loc_map{$_};
	my $curr = $_;
	if ($loc) {
		
		my $flag = 0;
		my $method = $_;
		$method =~ s/.*\/(.+)/$1/g;
		my $endp_flag = 0;
		my $ck = 0;
		my $var = '';
		my $no_entitle_flag = '';
		#print "$method\n";
		
		open(DATA, "<$loc") or die "Couldn't open file file.txt, $!";
		while(<DATA>) {
			
			if (/.*EntitlementAuditUtil\s+(\S+)\s*=.*;/) {
				$flag = 1;
				$var = $1;
				
				#print "$&\n";
				next;
			}
			if (/.*\@EndPoint.*/ && $flag) {
				$endp_flag = 1;
				next;
			}
			if (/.*public .*\Q$method\E\(/ && $endp_flag) {
				$endp_flag = 0;
				$ck = 1;
				next;
			} elsif (/.*public .* (\w+)\(.*/ && !$flag) {
				last;
			}
			if (/^\s*(\Q$var\E\..*)$/ && $ck) {
				print $curr;
				print "\t\t->\t\t$1\n";
				last;
			}
			
		}
		if ($flag) {
			$count++;
		}
		close(DATA);
	} else {
		print "$_ not found path";
	}
}
print $count;