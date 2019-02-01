use strict;
use warnings;

use Excel::Writer::XLSX;

my $sep = '$$$';
my $src = 'v2_refine.txt';

my @heads = ('MODULE', 'URL', 'ENTITLEMENT', '2RD PARAM', 'METHOD SIGNATURE', 'JAVA_PATH');
my $workbook = Excel::Writer::XLSX->new( 'entitlement_report.xlsx' );
my $worksheet = $workbook->add_worksheet();

my $format = $workbook->add_format();
$format->set_bold();
$format->set_bg_color( '#00b0f0' );
$format->set_align( 'center' );

my $format_content1 = $workbook->add_format();
$format_content1->set_bg_color( '#dce6f1' );
my $format_content2 = $workbook->add_format();
$format_content2->set_bg_color( '#95b3d7' );

sub write_to_doc {
	my ($row, @dt) = @_;
	my $col = 0;
	foreach(@dt) {
		if ($row % 2 == 0) {
			$worksheet->write( $row, $col++, $_, $format_content1 );
		} else {
			$worksheet->write( $row, $col++, $_, $format_content2 );
		}
	}
}

sub write_header {
	my $col = 0;
	foreach(@heads) {
		$worksheet->write( 0, $col++, $_, $format );
	}
}

my $row = 1;

write_header();

open(DATA, "<$src") or die "cannot open file $!";
while(<DATA>) {
	write_to_doc($row++, split(/\Q$sep\E/, $_));
}

close(DATA);

$workbook->close();