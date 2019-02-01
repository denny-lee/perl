use strict;
use warnings;

my %map =();
my $tmp = '';
open(DATA, "<C:/Users/e657183/Desktop/xx.txt") or die "Couldn't open file , $!";
while(<DATA>) {
	if (/.*@(.*).statestr.com:(\w+)\s+(\d+)/) {
		if ($2 eq 'webappchain' ) {
			if (not exists $map{$1}) {
				$map{$1}=$3;
			} else {
				$tmp = $map{$1};
				$map{$1} = $tmp . ',' . $3;
			}
		}
	}
}
for (keys %map) {
	print("$_ : $map{$_}\r\n");
}
close(DATA);