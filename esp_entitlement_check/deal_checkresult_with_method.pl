use strict;
use warnings;

my $base = 'c:/coding/perl_prog/';
my $file_name = 'result_raw.txt';

sub format_print {
	my ($url, $entitle, $f_sign) = @_;
	# $entitle =~ s/\w+\.(.*)/$1/;
	if ($entitle =~ /no entitlement/) {
		print "$url\t\t->\t\tNONE\t\t->\t\t\t\t->\t\t$f_sign\n";
	} elsif ($entitle =~ /validateAdminFunction.*?,\s*((".*?")|([0-9A-za-z_]+))/) {
		print "$url\t\t->\t\tADMIN\t\t->\t\t$1\t\t->\t\t$f_sign\n";
	} elsif ($entitle =~ /validateUserManageRoles.*?/) {
		print "$url\t\t->\t\tUSER\t\t->\t\tNULL\t\t->\t\t$f_sign\n";
	} elsif ($entitle =~ /validateMetamodelFunctionViaModel.*?,\s*((".*?")|([0-9A-za-z_]+))/) {
		print "$url\t\t->\t\tMETAMODEL_VIA_MODEL\t\t->\t\t$1\t\t->\t\t$f_sign\n";
	} elsif ($entitle =~ /getFunctionDetail.*?,\s*((".*?")|([0-9A-za-z_]+))/) {
		print "$url\t\t->\t\tGET_DETAIL\t\t->\t\t$1\t\t->\t\t$f_sign\n";
	} elsif ($entitle =~ /validateEmptyFunction.*?,\s*((".*?")|([0-9A-za-z_]+))/) {
		print "$url\t\t->\t\tEMPTY\t\t->\t\t$1\t\t->\t\t$f_sign\n";
	} elsif ($entitle =~ /disabledFunction.*?,\s*((".*?")|([0-9A-za-z_]+))/) {
		print "$url\t\t->\t\tDISABLED\t\t->\t\t$1\t\t->\t\t$f_sign\n";
	} elsif ($entitle =~ /validateMetamodelFunction.*?,\s*((".*?")|([0-9A-za-z_]+))/) {
		print "$url\t\t->\t\tMETAMODEL\t\t->\t\t$1\t\t->\t\t$f_sign\n";
	} else {
		print "$url\t\t->\t\t$entitle\t\t->\t\tNULL\t\t->\t\t$f_sign\n";
	}
	
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
		if (/^\s+(\S+)\t\t(.+?)\t\t(.+)/) {
			format_print ($curr_java.$1, $2, $3);
		}
		
		
	}
	
	close(DATA);
	return 1;
}

parseJava ($base.$file_name);