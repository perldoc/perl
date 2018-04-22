#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

my $target = 'target.txt';
open FH2, ">$target" || die "Cannot open $target.\n";

for (1..100){
	print FH2 "www.example$_.com $_\n";
}
for (101..200){
	print FH2 "www.example$_.com\n";
}
close(FH2);
	

