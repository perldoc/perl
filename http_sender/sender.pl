#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use 5.010;

my %target = &target;
my %request = &request;

for my $url (keys %target) {
	my $ua = LWP::UserAgent->new;
	my $server_endpoint = "http://" . $url . ":$target{$url}" . $request{"url"};
	

	
	# set custom HTTP request header fields
	if($request{"method"} eq "GET"){
		my $req = HTTP::Request->new(GET => $server_endpoint);
	} elsif($request{"method"} eq "POST") {
		my %post_data = map { split /=/ } split /&/, $request{"POST_DATA"};
		my $req = HTTP::Request->new(POST => $server_endpoint, [ %post_data ]); # [ %post_data ] 이해 필요
		my $resp = $ua->request($req);
		if ($resp->is_success) {
			print "HTTP GET response code: ", $resp->code, "\n";
			print "HTTP GET response message: ", $resp->message, "\n";

			my $header = $resp->headers_as_string;
			print "Received Header : $header\n";

			my $message = $resp->decoded_content;
			print "Received reply: $message\n";
		} else {
			print "HTTP GET error code: ", $resp->code, "\n";
			print "HTTP GET error message: ", $resp->message, "\n";

			my $header = $resp->headers_as_string;
			#print "Received Header : $header\n";

			my $message = $resp->decoded_content;
			#print "Received reply: $message\n";
		}	
	}

#	#header manual setup
#	for (keys %request) {
#		next if /method|url|POST_DATA/;
#		$req->header($_ => $request{$_});
#	}


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
	if(/.+=.+&*/){
		$request{"POST_DATA"} = $_ ;
		next;
	}
	next if /^\s*$/;
	
	my ($title, $value) = split /:/;
	$title =~ s/^\s+|\s+$//g;
	$value =~ s/^\s+|\s+$//g;
	$request{$title} = $value;
	}
	
#	my %test = map { split /=/ } split /&/, $request{"POST_DATA"};
#
#	foreach (keys %test) {
#		say "$_ : $test{$_}";
#	}	
	foreach (keys %request) {
		say "$_ : $request{$_}";
	}
	close(FH1);
	return %request;
}