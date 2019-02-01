use strict;
use warnings;
use 5.010;

use File::Find;
my %data;
find(sub { $data{$1."->".$2."\r\n"}=0 if -d && $File::Find::name=~m/C:\\workspace\\beacon\/(.*)\/src\/modules\/(.*?)\/.*/}, 'C:\workspace\beacon');
print sort(keys %data);