#! /usr/bin/perl
use strict;
use warnings;

open (file,'<',"input_data");

# A is opponent Rock
# B is opponent Paper
# C is opponent Scissors

# X is your Rock
# Y is your Paper
# Z is your Scissors

# Win is worth 6 pts.
# Draw is worth 3 pts.
# Loss is worth 0 pts.

# Rock is worth 1 pts
# Paper is worth 2 pts
# Scissors is worth 3 pts

my @games;
my $counter=0;

while (<file>)
{
    chomp($_);
    my @game = split ' ',$_;
    my $points = 0;
    #This is for part 2 comment it out to do part 1
    $game[1] = shapeSelection($game[0],$game[1]);

    if ($game[1] eq "X")
    {
        $points= $points+1;
    }

    elsif($game[1] eq "Y")
    {
        $points= $points+2;
    }

    elsif($game[1] eq "Z")
    {
        $points = $points+3;
    }

    $points = $points + Outcome($game[0], $game[1]);
    $games[$counter] = $points;
    $counter++;
}

my $total_points= 0;
foreach (@games)
{
    $total_points = $total_points + $_;
}

print "My total points: $total_points\n";

sub Outcome
{
    my $opponent = $_[0];
    $opponent =~ s/A/X/;
    $opponent =~ s/B/Y/;
    $opponent =~ s/C/Z/;

    if($opponent eq $_[1])
    {
        #Draw
        return 3;
    }

    elsif($_[0] eq "A" && $_[1] eq "Z")
    {
        #Loss
        return 0;
    }
    elsif($_[0] eq "B" && $_[1] eq "X")
    {
        #Loss
        return 0;
    }
    elsif($_[0] eq "C" && $_[1] eq "Y")
    {
        #Loss
        return 0;
    }
    else
    {
        #Win
        return 6;
    }
}

sub shapeSelection
{
    my $opponent = $_[0];
    $opponent =~ s/A/X/;
    $opponent =~ s/B/Y/;
    $opponent =~ s/C/Z/;

    # Y means draw
    if($_[1] eq "Y")
    {
        return $opponent;
    }

    # X means lose
    elsif($_[1] eq "X")
    {
        $opponent= $_[0];
        $opponent =~ s/A/Z/;
        $opponent =~ s/B/X/;
        $opponent =~ s/C/Y/;
        return $opponent;
    }

    # Z means win
    elsif($_[1] eq "Z")
    {
        $opponent= $_[0];
        $opponent =~ s/A/Y/;
        $opponent =~ s/B/Z/;
        $opponent =~ s/C/X/;
        return $opponent;
    }
}