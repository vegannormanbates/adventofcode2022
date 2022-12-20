#! /usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);

open (file,'<',"input_data");

my @valves; #Each Valve has a name, flow rate, and a number of neighbors
my @moves = 30; #Each move is 1 minute.

while(<file>)
{

}