#! /usr/bin/perl
use strict;
use warnings;

open (file,'<',"input_data");

my @trees; #Day 9 made using nested arrays way easier.
my $x=0;
my $y=0;

while (<file>)
{
    chomp $_;
    foreach my $char (split //, $_)
    {
        @{$trees[$y]}[$x] = $char;
        $x++;
    }
    $x=0;
    $y++;
}
# This will let you print the size of the nested array: @{@trees[0]}
# This will tell let you know number of nested arrays:  @trees

my $curRow = 0; #Row is Y
my $curColumn = 0; #Column is X
my @scenicScores;
my $height = @trees;
my $width = @{@trees[0]};

while($curRow < (@trees-1))
{
    while($curColumn < (@{@trees[0]} -1))
    {
        my $leftScore = 0;
        my $rightScore = 0;
        my $upScore = 0;
        my $downScore = 0;
        my $scenicScore = 0;

        my $tree =@{$trees[$curRow]}[$curColumn];

        #use range operator to copy parts of arrays without loops
        my @row_left = @{$trees[$curRow]}[0 .. $curColumn - 1];
        my @row_right = @{$trees[$curRow]}[$curColumn+1 ..$width-1];
        #use map and range to process a column without loops
        my @column_up = map {$trees[$_][$curColumn]} 0 .. $curRow - 1;
        my @column_down = map {$trees[$_][$curColumn]} $curRow + 1 .. $height - 1;

        #if there is no neighbor perl just doesn't start the loop -
        # Solving the problems I was having finding the edges yesterday.
        for my $neighbor (reverse @row_left)
        {
            $leftScore++;
            last if($tree <= $neighbor);
        }
        for my $neighbor (@row_right)
        {
            $rightScore++;
            last if($tree <= $neighbor);
        }
        for my $neighbor (reverse @column_up)
        {
            $upScore++;
            last if($tree <= $neighbor);
        }
        for my $neighbor (@column_down)
        {
            $downScore++;
            last if($tree <= $neighbor);
        }

        $curColumn++;
        $scenicScore = $leftScore * $rightScore * $downScore * $upScore;
        push (@scenicScores, $scenicScore);
    }
    $curRow++;
    $curColumn=0;
}

@scenicScores = sort({$b <=> $a} @scenicScores);
print "Part 2 Answer: $scenicScores[0]\n";