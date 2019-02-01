use strict;
use warnings;
use 5.010;

use File::Find;
my $total;
find(sub { $total += -s if -f}, 'C:\workspace\beacon');
say $total/1024/1024/1024;