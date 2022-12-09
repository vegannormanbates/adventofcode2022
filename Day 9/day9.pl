#! /usr/bin/perl
use strict;
use warnings;
use List::MoreUtils qw(uniq);
use Data::Dumper;

open (file,'<',"input_data");

my @hLocation = (0,0);
my @tLocation = (0,0);
my @tHistory;
$tHistory[0] = "0,0";
my @knots;
my $numTails=9;

my $count=0;
while ($count < $numTails)
{
    $knots[$count]= [0,0];
    $count++;
}

while(<file>)
{
    chomp $_;
    my @hMove = split(' ',$_);
    my $count = 0;
 

    while ($count < $hMove[1])
    {
        my $tailCount=0;
        if($hMove[0] eq 'R')
        {
            $hLocation[0] = $hLocation[0]+1;
        }
        elsif($hMove[0] eq 'L')
        {
            $hLocation[0] = $hLocation[0]-1;
        }
        elsif($hMove[0] eq 'U')
        {
            $hLocation[1] = $hLocation[1]+1;
        }
        elsif($hMove[0] eq 'D')
        {
            $hLocation[1] = $hLocation[1]-1;
        }
        if(distance($hLocation[0],$hLocation[1],@{$knots[0]}[0],@{$knots[0]}[1]) > 1)
        {
            my @tempCoords = tailMove($hLocation[0],$hLocation[1],@{$knots[0]}[0],@{$knots[0]}[1]);
            @{$knots[0]}= @tempCoords;
        }
        $count++;

        while($tailCount < ($numTails -1))
        {
            my @newHead = (@{$knots[$tailCount]}[0],@{$knots[$tailCount]}[1]);
            $tailCount++;
            my @newTail = (@{$knots[$tailCount]}[0],@{$knots[$tailCount]}[1]);
            if(distance($newHead[0],$newHead[1],$newTail[0],$newTail[1]) > 1 && ($tailCount < $numTails))
            {
                my @tempCoords = tailMove($newHead[0],$newHead[1],$newTail[0],$newTail[1]);
                @{$knots[$tailCount]}= @tempCoords;
            }
            if($tailCount==8)
            {
                push(@tHistory,("@{$knots[$tailCount]}[0],@{$knots[$tailCount]}[1]"));
            }
        }
    }
}

print "Unique Locations:".scalar uniq(@tHistory)."\n";

sub distance
{
    my @headCoords = ($_[0], $_[1]);
    my @tailCoords = ($_[2], $_[3]);

    if (($headCoords[0]==$tailCoords[0]) && ($headCoords[1] == $tailCoords[1]))
    {
        return 0; #same space
    }
    elsif(abs($headCoords[0]-$tailCoords[0]) + abs($headCoords[1]- $tailCoords[1]) == 1 || 
    (abs($headCoords[0] - $tailCoords[0]) == 1 && abs(($headCoords[1])-$tailCoords[1]) == 1))
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

sub tailMove
{
    my @headCoords = ($_[0], $_[1]);
    my @tailCoords = ($_[2], $_[3]);
    my $move;

    if($headCoords[0] == $tailCoords[0])
    {
        #In the same column - need to move up or down.
        $move = $headCoords[1] - $tailCoords[1];
        $move = $move/abs($move); #should always return a value with the correct sign
        $tailCoords[1]+= $move;

    }
    elsif($headCoords[1] == $tailCoords[1])
    {
        #In the same row - need to move left or right.
        $move = $headCoords[0] - $tailCoords[0];
        $move = $move/abs($move);
        $tailCoords[0]+= $move;
    }
    else
    {
        #diagonal
        $move = $headCoords[1] - $tailCoords[1];
        $move = $move/abs($move);
        $tailCoords[1]+= $move;

        $move = $headCoords[0] - $tailCoords[0];
        $move = $move/abs($move);
        $tailCoords[0]+= $move;
    }
    return $tailCoords[0],$tailCoords[1];
}