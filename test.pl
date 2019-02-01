use strict;
use warnings;

my $emp = 0;
my $comment = 0;
my $comment2 = 0;
my $flag = 0;
open(DATA, "<C:/Users/e657183/Desktop/ECFControler.java") or die "Couldn't open file , $!";
while(<DATA>) {
	
	
	if (/.*\*\/\s*$/ && $flag) {
		$flag = 0;
		$comment2++;
		next;
	}
	if ($flag) {
		$comment2++;
		next;
	}
	if (/^\s*\/\*.*/ && !$flag) {
		$comment2++;
		$flag = 1;
		next;
	}
	
	if (/^\s$/) {
		$emp++;
		next;
	}
	
	$comment++ if /^\s*\/\/.*$/;
}
close(DATA);
print("$emp\r\n");
print("$comment2\r\n");
print("$comment\r\n");