#! /usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use List::Util qw(sum);

open (file,'<',"input_data");

my $cycleCount = 1;
my $signalStrength = 0; # Calcualated at 20 cycles then every 40 there after = $x * $cycleCount
my @interestingSignals;
my $x = 1;
my $lastCommand;
my @cycleBuffer;

while(<file>)
{
    my @command = split(' ',$_);
    if ($command[0] eq "noop")
    {
        $cycleCount++;
        push(@cycleBuffer,$x);
        if (calcStrength($cycleCount, $x) >= 0)
        {
            $signalStrength = calcStrength($cycleCount, $x);
            push(@interestingSignals, $signalStrength);
        }
    }
    elsif ($command[0] eq "addx")
    {
        $cycleCount++;
        push(@cycleBuffer,$x);
        if (calcStrength($cycleCount, $x) >= 0)
        {
            $signalStrength = calcStrength($cycleCount, $x);
            push(@interestingSignals, $signalStrength);
        }
        $cycleCount++;
        push(@cycleBuffer,$x);
        $x+= $command[1];
        if (calcStrength($cycleCount, $x) >= 0)
        {
            $signalStrength = calcStrength($cycleCount, $x);
            push(@interestingSignals, $signalStrength);
        }
    }
}
my $interestingSum = sum(@interestingSignals);
print "\nPart 1: $interestingSum\n";
print "Part 2:\n\n";
my $count = 0;
while ($count < $cycleCount-1)
{
    my $pixel = $cycleBuffer[$count];
    draw($count,$pixel);
    $count++;
}
print "\n";

sub calcStrength
{
    my $cycleCount = $_[0];
    my $x = $_[1];
    if ($cycleCount == 20 || (($cycleCount-20)%40== 0))
    {
        $signalStrength = $x * $cycleCount;
        return $signalStrength;
    }
    else
    {
        return -1;
    }
}

sub draw
{
    my $cycleCount = $_[0];
    my $x = $_[1];

    if (abs($x -($cycleCount%40)) <= 1)
    {
        print "#";
    } 
    else
    {
        print ".";
    }
    if( ($cycleCount+1) % 40 == 0) 
    {
        print "\n";
    }
}