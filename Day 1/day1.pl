#! /usr/bin/perl
use strict;
use warnings;

open (file,'<',"input_data");

my @elves=();
my $counter=0;

while (<file>)
{
    chomp($_);
    if ($_ eq ""|| $_ eq " ")
    {
       $counter++;
       $elves[$counter]=0;
       next;
    }
    elsif ($_ > 0)
    {
        $elves[$counter]= $elves[$counter] + $_;
    }

}

@elves = sort {$b <=> $a} @elves;

print "Top 3 Total Calories: ";
my $top3 = $elves[0]+$elves[1]+$elves[2];
print $top3."\n";

