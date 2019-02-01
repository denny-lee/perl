use strict;
use warnings;

use File::Find;

my $file;


sub parseJava {
	my ($fb3) = @_;
	
	#print "$fb3\r\n";
	
	open(DATA, "<$fb3") or die "Couldn't open file file.txt, $!";
	while(<DATA>) {
		if (/.*getFetchSize.*/i) {
			print $&;
			print $fb3;
			print "\n";
			next;
		}
		
	}
	
	
	close(DATA);
	return 1;
}

sub listFiles {
	my ($fb2) = @_;
	if (-e $fb2) {
		#print "$fb2\r\n";
		find(sub { (parseJava ($File::Find::name)) if /.*\.java$/}, $fb2);
	}
}
my $base = $ARGV[0];
if ($base) {
	print $base;
	my $lm = \&listFiles;

	opendir (DIR, $base) or die "Couldn't open directory, $!";
	while ($file = readdir DIR) {
	   &$lm("$base/$file") if (-d "$base/$file") && not $file =~ /^\..*/;
	}
	closedir DIR;
}

