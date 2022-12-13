#! /usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use List::Util qw(sum);

open (file,'<',"input_data");
my @data;
while (<file>)
{
    chomp $_;
    push(@data,$_);
}
#keeps lines that are numbers, brackets and commas. eval builds data structure.
my @packets = map {eval} grep {/^[][0-9,]+$/} @data;

my @pairs;
@pairs = grep {$_ % 2 == 0} keys @packets; #finds the index # for each pair.
@pairs = grep {compare ($packets [$_], $packets [$_ + 1]) < 0} @pairs; #Finds each pair that is in the right order
print "Part 1: ". sum map  {1 + ($_ / 2)} @pairs;
print "\n";

my @sorted;
# perl thinks the mismatched brackets are a syntax error and breaks my program - however if I make them part of a bigger list it works?
# Making packets a list of lists to match the formatting of the divider characters.
@packets = map{[0=>$_]} @packets;
@sorted = sort {compare ($$a[1], $$b[1])} [1,[[2]]],[1,[[6]]],@packets;
my @dividers = grep {$sorted[$_][0]} keys @sorted;
@dividers = map {$_ +1} @dividers;
print "Part 2: ".$dividers[0] * $dividers[1]."\n";

sub compare
{
    my $packet1 = $_[0];
    my $packet2 = $_[1];

    if (!ref($packet1) && !ref($packet2))
    {
        return $packet1 <=> $packet2;
    }
    if (!ref($packet1))
    {
        return compare ([$packet1], $packet2);
    }
    if(!ref($packet2))
    {
        return compare ($packet1, [$packet2]);
    }
    if(!@$packet1 && !@$packet2)
    {
        return 0;
    }
    if(!@$packet1)
    {
        return -1;
    }
    if(!@$packet2)
    {
        return 1;
    }
    return compare ($$packet1[0], $$packet2[0]) || compare ([@$packet1[1..$#$packet1]], [@$packet2[1 .. $#$packet2]]); 
}