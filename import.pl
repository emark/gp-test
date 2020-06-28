#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use lib '/home/hosting_3bears/perl5/lib/perl5';

use DBIx::Custom;
use YAML::XS 'LoadFile';

my $config = LoadFile('config.yaml');

my $dbi = DBIx::Custom->connect(
   dsn => "dbi:mysql:database=$config->{'database'}",
   user => $config->{'user'},
   password => $config->{'pass'},
   option => {mysql_enable_utf8 => 1}
);

open (FILE,"< source/out") || die "Can't open file: out";
	&ParseLog(<FILE>);
close(FILE);

sub ParseLog{
my $n = 0;#Total counter
my $m = 0;#Счетчик сообщений
my $l = 0;#Счетчик прочих строк
my $source = '';
my %data = ();

	foreach my $str(@_){
		$source = '';
		my($date, $time, $int_id, $flag)=split(/ /,$str);
		$str =~s/$date $time //;#Убираем timestamp

		if ($flag eq '<='){
			my $id = $str;
			$id =~s/id=(.*)//;#Crop id
			if($1){
				$id = $1;
			}else{
				$id = '';

			};

			$source = 'message';
			%data = (
				created => "$date $time",
				int_id => "$int_id",
				str => "$str",
				id => "$id",
			);
			$m++;

		}else{
			my $address = $str;
			$address =~s/ (.+\@.+\.[a-z]+)\:* //;#Crop email
			if($1){
				($flag, $address) = split(/ /,$1);
				
			}else{
				$address = '';

			};
			
			$int_id = '' if($int_id!~m/\w{6}\-\w{6}\-\w{2}/);#Checkng exists of int_id
		
			$source = 'log';
			%data = (
				created => "$date $time",
				int_id => "$int_id",
				str => "$str",
				address => "$address",
			);
			$l++;

		};

		$dbi->insert(
			{%data},
			table => $source,	
		);
		%data = ();
		$n++;
		print "Parse string: $n\tmsg=$m\tlog=$l\n";
	};

print "Import completed.\n";
1;
};

1;
