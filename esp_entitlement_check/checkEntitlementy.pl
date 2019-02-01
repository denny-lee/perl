use strict;
use warnings;

use File::Find;

my $file;
my $base = 'c:/workspace/beacon';
my $javacount = 0;
my %entitle_map;

sub format_print {
	my ($url, $cfile, @ep) = @_;
	print "$url\t\t$cfile\n";
	foreach(@ep) {
		if ($entitle_map{$_}) {
			print "\t/$_\t\t$entitle_map{$_}\n";
		} else {
			print "\terror for \t/$_\n"
		}
	}
}

sub parseJava {
	my ($fb3) = @_;
	my $has_ctrl = 0;
	my $endp_flag = 0;
	my $entitle_flag = 0;
	my $var_name = '';
	my $var_flag = 0;
	my @raw;
	my $url_mapping = '0';
	my $curr_fun = '';
	
	#print "$fb3\r\n";
	
	open(DATA, "<$fb3") or die "Couldn't open file file.txt, $!";
	while(<DATA>) {
		if ((! $has_ctrl) && /.*public\s+class\s+.*/) {
			last;
		}
		if (/.*\@Controller\("([\/\w]+).*/) {
			$url_mapping = $1;
			$has_ctrl = 1;
			next;
		} elsif (/.*\@Controller.*/) {
			$url_mapping = '/';
			$has_ctrl = 1;
			next;
		}
		
		if (/.*\@EndPoint.*/) {
			$endp_flag = 1;
			next;
		}
		
		if ((/.*public .* (\w+)\(.*/) && $endp_flag) {
			if ($entitle_flag) {
				$entitle_map{$curr_fun} = 'no entitlement';
			} else {
				$entitle_flag = 1;
			}
			$var_name = '';
			push @raw, $1;
			$curr_fun = $1;
			$endp_flag = 0;
			next;
		} elsif (/.*public .* (\w+)\(.*/) {
			if ($entitle_flag) {
				$entitle_map{$curr_fun} = 'no entitlement';
				$entitle_flag = 0;
			}
			$var_name = '';
		}
		
		if ((/.*EntitlementAuditUtil\s+(\S+)\s*=.*/) && $entitle_flag) {
			$var_flag = 1;
			$var_name = $1;
			# $entitle_flag = 1;
			next;
		}
		
		if ( $var_name ne '' && (/.*(\Q$var_name\E\..*)/) && $entitle_flag) {
			$entitle_map{$curr_fun} = $1;
			$var_flag = 0;
			$var_name = '';
			$entitle_flag = 0;
			next;
		}
		
		if (/.*EntitlementAuditUtil\.class\)\.(.*)/ && $entitle_flag) {
			$entitle_map{$curr_fun} = $1;
			$entitle_flag = 0;
			next;
		}
	}
	
	if ($entitle_flag) {
		$entitle_map{$curr_fun} = 'no entitlement';
		$entitle_flag = 0;
	}
	close(DATA);
	format_print ($url_mapping, $fb3, @raw) if $url_mapping;
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

print $javacount;