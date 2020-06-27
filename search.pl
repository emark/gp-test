#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use DBIx::Custom;
use CGI qw/:standard/;

my $q = CGI->new();
my $address = $q->param('address') || '';

my $dbi = DBIx::Custom->connect(
  "dbi:mysql:database=gptest",
  'root',
  'admin',
  {mysql_enable_utf8 => 1}
);

print $q->header();

print "<html><head><title>Search</title></head><body><h1>Search form</h1><form method=post><input type=text value=\"$address\" name=address>&nbsp;<input type=submit value=Search>";

if($address){
	my $result = $dbi->select(
		table => 'log',
		column => 'int_id',
		where => {'address' => $address},
		append => 'group by int_id',
	)->fetch_all;

	print "<pre>\n\n";
	print "Result for address: $address\n\n<ol>";
	
	foreach my $int_id(@{$result}){
		print "<li>$int_id->[0]</li>\n";
	};

	print "</ol></pre>";

};

print "</body></html>";
1;
