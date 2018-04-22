#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use 5.010;
use LWP::UserAgent;

my %target = &target;
my %request = &request;

for my $url (keys %target) {

	if($target{$url} > 0){
		
		my $ua = LWP::UserAgent->new;
		my $server_endpoint = "http://" . $url . ":$target{$url}" . $request{"url"};

		# set custom HTTP request header fields
		my $req = HTTP::Request->new(GET => $server_endpoint);
		for (keys %request) {
			next if /method|url/;
			$req->header($_ => $request{$_});
		}
		
		my $resp = $ua->request($req);
		if ($resp->is_success) {
			print "HTTP GET response code: ", $resp->code, "\n";
			print "HTTP GET response message: ", $resp->message, "\n";
			
			my $header = $resp->headers_as_string;
			print "Received Header : $header\n";
		
			my $message = $resp->decoded_content;
			print "Received reply: $message\n";
		}
		else {
			print "HTTP GET error code: ", $resp->code, "\n";
			print "HTTP GET error message: ", $resp->message, "\n";
			
			my $header = $resp->headers_as_string;
			print "Received Header : $header\n";
		
			my $message = $resp->decoded_content;
			print "Received reply: $message\n";


		}	
	}
}

sub target {
	my $target = 'target.txt';
	open FH2, "<$target" || die "Cannot open $target.\n";

	my %target_port = ();
	my ($before, $url, $port) = 0;
	foreach (<FH2>) {
		chomp;
		if(/ \d{1,5}$/) {
			($url, $port) = split /\s+/;
			$before = $port;
		}
		else{
			$url = $_;
			$port = $before;
		}
		$target_port{$url} = $port;
	}
	close(FH2);
	return %target_port;
}
sub request {
	my $request = 'request.txt';
	open FH1, "<$request" || die "Cannot open $request.\n";

	my %request = ();
	my $methomd_url = <FH1>;
	my ($method, $url) = split /\s+/, $methomd_url;
	$method =~ s/^\s+|\s+$//g;
	$url =~ s/^\s+|\s+$//g;
	$request{"method"} = $method;
	$request{"url"} = $url;
	
	foreach (<FH1>){
	  my ($title, $value) = split /:/;
	  $title =~ s/^\s+|\s+$//g;
	  $value =~ s/^\s+|\s+$//g;
	  $request{$title} = $value;
	}

	close(FH1);
	return %request;
}