#! /usr/bin/perl
use strict;
use warnings;

open (file,'<',"input_data");

my $numOverlapping;

while(<file>)
{
    chomp($_);
    my @elves = split (/,/,$_);
    my @elf1 = split (/-/,@elves[0]);
    my @elf2 = split (/-/,@elves[1]);

    if ($elf1[0]>=$elf2[0] && $elf1[1]<=$elf2[1] )
    {
        $numOverlapping++;
    }
    elsif ($elf2[0]>=$elf1[0] && $elf2[1]<=$elf1[1])
    {
        $numOverlapping++;
    }
    elsif ($elf1[0]>=$elf2[0] && $elf1[0]<=$elf2[1])
    {
        $numOverlapping++;
    }
    elsif ($elf1[1]>=$elf2[0] && $elf1[1]<=$elf2[1])
    {
        $numOverlapping++;
    }
    elsif ($elf2[0]>=$elf1[0] && $elf2[0]<=$elf1[1])
    {
        $numOverlapping++;
    }
    elsif ($elf2[1]>=$elf1[0] && $elf2[0]<=$elf1[1])
    {
        $numOverlapping++;
    }
}

print $numOverlapping."\n";