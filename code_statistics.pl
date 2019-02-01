use strict;
use warnings;

use File::Find;

my $file;
my $base = 'c:/workspace/beacon';
my $javacount = 0;
my $total_lines = 0;
my $comment_lines = 0;
my $empty_lines = 0;
my $flag = 0;

sub parseJava {
	my ($fb3) = @_;
	
	#print "$fb3\r\n";
	
	open(DATA, "<$fb3") or die "Couldn't open file file.txt, $!";
	while(<DATA>) {
		if (/.*\*\/\s*$/ && $flag) {
			$flag = 0;
			$comment_lines++;
			next;
		}
		if ($flag) {
			$comment_lines++;
			next;
		}
		if (/^\s*\/\*.*/ && !$flag) {
			$comment_lines++;
			$flag = 1;
			next;
		}
		
		if (/^\s$/) {
			$empty_lines++;
			next;
		}
		
		$comment_lines++ if /^\s*\/\/.*$/;
	}
	$total_lines += $.;
	
	close(DATA);
	return 1;
}

sub listFiles {
	my ($fb2) = @_;
	if (-e $fb2) {
		#print "$fb2\r\n";
		find(sub { (parseJava ($File::Find::name)) && $javacount++ if /.*\.java$/}, $fb2);
	}
}

sub listModules {
	my ($fb1) = @_;
	my $ff;
	if (-e $fb1) {
		opendir (DIRM, $fb1) or die "Couldn't open directory, $!";
		while ($ff = readdir DIRM) {
		   listFiles ("$fb1/$ff/src/com") if (-d "$fb1/$ff") && not $ff =~ /^\..*/;
		}
		closedir DIRM;
	}
	
}

my $lm = \&listModules;

opendir (DIR, 'c:\workspace\beacon') or die "Couldn't open directory, $!";
while ($file = readdir DIR) {
   &$lm("$base/$file/src/modules") if (-d "$base/$file") && $file=~/^esp_.*/;
}
closedir DIR;

print "java files : $javacount\r\n";
print "lines : $total_lines";
my $valid_lines = $total_lines - $comment_lines - $empty_lines;
print "valid lines : $valid_lines";
print "empty lines : $empty_lines";