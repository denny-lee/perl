use strict;
use warnings;

my $aa = '    public Document compareMetaModel(Document inputDocument,';
my $bb = '	    @EISInject(type = Type.Header, value = "sm_user") String smUserId) throws Exception {';
my $cc = 'abc			abc ';
if ($aa =~ /(?!.*\{\s*)^.*$/ ) {
	print 'T';
} else {
	print 'F';
}

if ($bb =~ /(?=.*\{\s*)^.*$/ ) {
	print 'T';
} else {
	print 'F';
}

if ($cc =~ '(.*?)\s') {
	print "\n$1";
}

$cc =~ s/\t+/ /g;
print "\n$cc";
