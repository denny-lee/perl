use strict;
use warnings;

my $parse_java_recrusively = 'checkEntitlementy_with_method_v2.pl';
my $plat_show = 'deal_checkresult_with_method_v2.pl';
my $write_to_xlsx = 'write_xlsx.pl';

my $bs = $ARGV[0];
if (!$bs) {
	print 'need base dir';
	exit(-1);
}

print "Start parsing Java, please wait!\n";
system("$parse_java_recrusively $bs > v2_raw.txt");
print "Parsing Java done\n";

print "Start digesting data\n";
system("$plat_show $bs > v2_refine.txt");
print "Digesting data done\n";

print "Start writing to xlsx\n";
system($write_to_xlsx);
print "ALL DONE\n";