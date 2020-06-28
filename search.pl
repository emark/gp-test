#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use DBIx::Custom;
use CGI qw/:standard/;
use YAML::XS 'LoadFile';
use Data::Dump qw(dump);

my $config = LoadFile('config.yaml');

my $q = CGI->new();
my $address = $q->param('address') || '';

my $dbi = DBIx::Custom->connect(
   dsn => "dbi:mysql:database=$config->{'database'}",
   user => $config->{'user'},
   password => $config->{'pass'},
   option => {mysql_enable_utf8 => 1}
);

my $limit = 100;

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
	
	my $n = 0;
	foreach my $int_id(@{$result}){
		my $result = $dbi->execute(
			"select message.created, str from message where int_id=:int_id union select created, str from log where int_id=:int_id order by created",
			{int_id => $int_id->[0]},
	
		)->fetch_all;

		foreach my $row(@{$result}){
			print "<li>$row->[0]\t$row->[1]\n";
			$n++;
			if($n == $limit){
				print "\nReached limit rows.";
				print "</ol></pre>";
				print "</body></html>";
				exit;

			};
		};

	};

	print "</ol></pre>";

};

print "</body></html>";

1;
