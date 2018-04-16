#!/usr/bin/perl
use POSIX qw(strftime);
use strict;
use warnings;
use 5.010;

my $file_name = shift @ARGV;
open(FH_IN, "<", $file_name) or die $!;
open(FH_OUT, ">", "out_".$file_name) or die $!;
my @allLines = <FH_IN>;

my $month_day = strftime "%m%d", localtime;

print FH_OUT "config firewall address\n";
foreach (@allLines){
	if(/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/){
		my $ip = $1;
		my $foti_format = $ip;
		$foti_format =~ s/^/edit BL_/;
		$foti_format =~ s/$/_H_$month_day\nset subnet $ip 255\.255\.255\.255\nnext\n/;
		print FH_OUT $foti_format;
	}
	elsif(/([\w|\d]+\..+[\w|\d]+)/){
		my $url = $1;
		$url =~ s/\/.*//;
		my $foti_format = $url;		
		$foti_format =~ s/^/edit BL_/;
		$foti_format =~ s/$/_$month_day\nset subnet\nset type fqdn\nset fqdn $url\nnext\n/;
		print FH_OUT $foti_format;
	}
}

close(FH_IN);
close(FH_OUT);