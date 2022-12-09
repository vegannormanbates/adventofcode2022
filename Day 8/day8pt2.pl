#! /usr/bin/perl
use strict;
use warnings;

open (file,'<',"input_data");

my %trees;
my $x=0;
my $y=0;
my $maxX=0;
my $maxY=0;

while (<file>)
{
    chomp $_;
    foreach my $char (split //, $_)
    {
        $trees{"x$x"."y$y"}= $char;
        $x++;
    }
    $maxX = $x;
    $x=0;
    $y++;
}
$maxY = $y;
print "Max X: $maxX\n";
print "Max Y: $maxY\n";

my $curRow = 0; #Row is Y
my $curColumn = 0; #Column is X
my @scenicScores;

while($curRow < ($maxY-1))
{
    my $leftScore = 0;
    my $rightScore = 0;
    my $upScore = 0;
    my $downScore = 0;
    my $scenicScore = 0;
    while($curColumn < ($maxX -1))
    {
        if ($curColumn == 0 || $curColumn == ($maxX-1) || $curRow == 0 || $curRow == ($maxY-1))
        {
            $scenicScore = 0;
        }

        $curColumn++;
        push (@scenicScores, $scenicScore);
    }
    $curRow++;
}
