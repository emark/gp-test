#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use DBIx::Custom;

my $dbi = DBIx::Custom->connect(
  "dbi:mysql:database=gptest",
  'root',
  'admin',
  {mysql_enable_utf8 => 1}
);

open (FILE,"< out") || die "Can't open file: out";
	&ParseLog(<FILE>);
close(FILE);

sub ParseLog{
my $n = 0;
	foreach my $str(@_){
		my($date, $time, $int_id, $flag)=split(/ /,$str);
		$str =~s/$date $time //;
		print "$date, $time, $int_id, ";

		if ($flag eq '<='){		
			my $id = $str;
			$id =~s/id=(.*)//;
			print "$1" if($1);
			print "\n";
			$n++;

		}else{
			my $address = 

		};
	};
	
1;
};


1;
