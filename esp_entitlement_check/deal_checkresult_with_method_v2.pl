use strict;
use warnings;

# my $base = 'c:/coding/perl_prog/esp_entitlement_check/';
my $file_name = 'v2_raw.txt';
my $base_esp = $ARGV[0];

sub print_xls {
	#my $sep = "\t\t->\t\t";
	my $sep = '$$$';
	my $not_first = 0;
	foreach(@_) {
		if ($not_first) {
			print $sep;
		} else {
			$not_first = 1;
		}
		print $_;
	}
	print "\n";
}

sub retrive_module {
	my ($url) = @_;
	if ($url =~ /\/(\w+)/) {
		return $1;
	}
	return $url;
}

sub format_print {
	my ($url, $entitle, $f_sign, $j_file_name) = @_;
	$j_file_name =~ s/\Q$base_esp\E//i;
	my $module = retrive_module($url);
	# $entitle =~ s/\w+\.(.*)/$1/;
	if ($entitle =~ /no entitlement/) {
		print_xls($module, $url, 'NONE', '', $f_sign, $j_file_name);
	} elsif ($entitle =~ /validateAdminFunction.*?,\s*((".*?")|([0-9A-za-z_]+))/) {
		print_xls($module, $url, 'ADMIN', $1, $f_sign, $j_file_name);
	} elsif ($entitle =~ /validateUserManageRoles.*?/) {
		print_xls($module, $url, 'USER', 'NULL', $f_sign, $j_file_name);
	} elsif ($entitle =~ /validateMetamodelFunctionViaModel.*?,\s*((".*?")|([0-9A-za-z_]+))/) {
		print_xls($module, $url, 'METAMODEL_VIA_MODEL', $1, $f_sign, $j_file_name);
	} elsif ($entitle =~ /getFunctionDetail.*?,\s*((".*?")|([0-9A-za-z_]+))/) {
		print_xls($module, $url, 'GET_DETAIL', $1, $f_sign, $j_file_name);
	} elsif ($entitle =~ /validateEmptyFunction.*?,\s*((".*?")|([0-9A-za-z_]+))/) {
		print_xls($module, $url, 'EMPTY', $1, $f_sign, $j_file_name);
	} elsif ($entitle =~ /disabledFunction.*?,\s*((".*?")|([0-9A-za-z_]+))/) {
		print_xls($module, $url, 'DISABLED', $1, $f_sign, $j_file_name);
	} elsif ($entitle =~ /validateMetamodelFunction.*?,\s*((".*?")|([0-9A-za-z_]+))/) {
		print_xls($module, $url, 'METAMODEL', $1, $f_sign, $j_file_name);
	} else {
		print_xls($module, $url, 'NONE', 'NULL', $f_sign, $j_file_name);
	}
	
}

sub parseJava {
	my ($fb1) = @_;
	my $curr_line = '';
	my $j_file_name = '';
	my $str;
	
	open(DATA, "<$fb1") or die "Couldn't open file, $!";
	while(<DATA>) {
		if (/\s+\/\//) {
			next;
		}
		if (/^(\/\S+)\s+(.*)/) {
			$curr_line = $1;
			$j_file_name = $2;
			next;
		}
		if (/^\s+(\S+)\t\t(.+?)\t\t(.+)/) {
			format_print ($curr_line.$1, $2, $3, $j_file_name);
		}
		
		
	}
	
	close(DATA);
	return 1;
}

parseJava ($file_name);