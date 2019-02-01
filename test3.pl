my $aa = "/espws/irddmsimc/jdbc/runSQLBinary?guid=e497a2a7-1e43-4a21-b514-f1f45099dbf0-1&mart=ESP_DUAL&version=cds_base_11.10.00_0071_02_21_2011";

if ($aa =~ /\/[^\/]+\/[^\/]+(\/[^\s\?]+)/) {
	print "match";
	print "\n$1";
}