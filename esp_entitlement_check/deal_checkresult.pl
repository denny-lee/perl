use strict;
use warnings;

my $base = 'c:/coding/perl_prog/';
my $file_name = 'result.txt';

sub format_print {
	my ($url, $entitle) = @_;
	$entitle =~ s/\w+\.(.*)/$1/;
	print "$url\t\t->\t\t$entitle\n";
}

sub parseJava {
	my ($fb1) = @_;
	my $curr_java = '';
	my $str;
	
	open(DATA, "<$fb1") or die "Couldn't open file, $!";
	while(<DATA>) {
		if (/^(\/\S+)/) {
			$curr_java = $1;
			next;
		}
		if (/^\s+(\S+)\s+(.+)/) {
			format_print ($curr_java.$1, $2)
		}
		
		
	}
	
	close(DATA);
	return 1;
}

parseJava ($base.$file_name);