#!/usr/bin/env perl

use strict;


my $log = $ARGV[0];
my $format = $ARGV[1];
if (length($format) == 0) {
    $format = "+%F_%b.txt";
}

system("date $format") == 0 or die $!;
my $path = "$log";
print "Loading log\n";
open(my $file, $path) or die $!;
print "Log loaded\n";
my @lines = ();
my $name = "";

sub write_file {
    print "Wrote $name\n";
    open(my $f, ">", $name);
    foreach my $line (@lines) {
        print $f $line;
    }
    close($f);
    @lines = ();
}


foreach my $line (<$file>) {
    if ($line =~ m/^--- Day.*/) {
        if (length($name) > 0) {
           write_file();
        }
        my $date = substr($line, 16, length($line) - 1);
        $date = `date --date="$date" $format`;
        $name = $date;
        chomp $name;
        $line = "$line\n"

    }
    push(@lines, $line);
}
