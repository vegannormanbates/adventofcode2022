#! /usr/bin/perl
use strict;
use warnings;

open (file,'<',"input_data");
my %trees;
my $x=0;
my $y=0;
my $maxX=0;

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
my $maxY = $y;
my $numVis=0;
my $xCount=0;
my $yCount=0;
my $currentTallest =-1;
my %visTrees;

while ($xCount <= $maxX-1)
{
    my $tree = $trees{"x$xCount"."y$yCount"};

    if ($tree > $currentTallest && !exists($visTrees{"x$xCount"."y$yCount"}))
    {
        $numVis++;
        $currentTallest = $tree;
        $visTrees{"x$xCount"."y$yCount"} =  $trees{"x$xCount"."y$yCount"};
    }
    elsif ($tree > $currentTallest && exists($visTrees{"x$xCount"."y$yCount"}))
    {
        $currentTallest = $tree;
    }
    $xCount++;
    if($xCount>$maxX-1)
    {
        $currentTallest = -1;
        $yCount++;
        $xCount=0;

        if ($yCount> $maxY-1)
        {
            last;
        }
    }
}

$xCount= $maxX-1;
$yCount=0;
$currentTallest=-1;

while ($xCount >= 0)
{
    my $tree = $trees{"x$xCount"."y$yCount"};

    if ($tree > $currentTallest && !exists($visTrees{"x$xCount"."y$yCount"}))
    {
        $numVis++;
        $currentTallest = $tree;
        $visTrees{"x$xCount"."y$yCount"} =  $trees{"x$xCount"."y$yCount"};
    }
    elsif ($tree > $currentTallest && exists($visTrees{"x$xCount"."y$yCount"}))
    {
        $currentTallest = $tree;
    }
    $xCount--;
    if($xCount < 0)
    {
        $currentTallest = -1;
        $yCount++;
        $xCount=$maxX-1;

        if ($yCount > $maxY-1)
        {
            last;
        }
    }
}

$currentTallest=-1;
$yCount=0;
$xCount=0;

while ($yCount <= $maxY-1)
{
    my $tree = $trees{"x$xCount"."y$yCount"};

    if ($tree > $currentTallest && !exists($visTrees{"x$xCount"."y$yCount"}))
    {
        $numVis++;
        $currentTallest = $tree;
        $visTrees{"x$xCount"."y$yCount"} =  $trees{"x$xCount"."y$yCount"};
    }
    elsif ($tree > $currentTallest && exists($visTrees{"x$xCount"."y$yCount"}))
    {
        $currentTallest = $tree;
    }
    $yCount++;
    if($yCount>$maxY-1)
    {
        $currentTallest = -1;
        $xCount++;
        $yCount=0;

        if ($xCount> $maxX-1)
        {
            last;
        }
    }
}

$xCount = 0;
$yCount= $maxY-1;
$currentTallest=-1;

while ($yCount >= 0)
{
    my $tree = $trees{"x$xCount"."y$yCount"};

    if ($tree > $currentTallest && !exists($visTrees{"x$xCount"."y$yCount"}))
    {
        $numVis++;
        $currentTallest = $tree;
        $visTrees{"x$xCount"."y$yCount"} =  $trees{"x$xCount"."y$yCount"};
    }
    elsif ($tree > $currentTallest && exists($visTrees{"x$xCount"."y$yCount"}))
    {
        $currentTallest = $tree;
    }
    $yCount--;

    if($yCount < 0)
    {
        $currentTallest = -1;
        $xCount++;
        $yCount= $maxY-1;

        if ($xCount > $maxX-1)
        {
            last;
        }
    }
}
print "Part 1 Answer: ".$numVis."\n";

my $maxScore=0;
$yCount = 0;
$xCount = 0;
my %scores;


while ($yCount < $maxY)
{
    while ($xCount < $maxX-1)
    {
        my $height = $trees{"x$xCount"."y$yCount"};
        my $treesRight = ($maxX) - $xCount;
        my $treesLeft = $xCount;
        my $treesUp = $yCount;
        my $treesDown = ($maxY-1) - $yCount;
        my $curX = $xCount;
        my $curY = $yCount; 
        my $rightScore = 0;
        my $leftScore = 0;
        my $upScore = 0;
        my $downScore = 0;

        while ($curX <= $treesRight)
        {
            my $right=$curX+1;
            print $right."\n";
            if($xCount == $maxX)
            {
                $rightScore = 0;
                last;
            }
            elsif($height > $trees{"x$right"."y$yCount"})
            {
                $rightScore++;
                $curX++;
            }
            else
            {
                last;
            }
        }

        $curX= $xCount;
        while ($curX >= 0)
        {
            my $left=$curX-1;
            if($xCount == 0)
            {
                $leftScore = 0;
                last;
            }
            elsif($left == -1)
            {
                #$leftScore++;
                last;
            }
            elsif($height > $trees{"x$left"."y$yCount"})
            {
                $leftScore++;
                $curX--;
            }
            elsif ($xCount > 0 && $height <=$trees{"x$left"."y$yCount"})
            {
                $leftScore = 1;
                $curX--;
            }
            else
            {
                last;
            }
        }

        while ($curY >= $treesUp)
        {
            if($height > $trees{"x$xCount"."y$curY"})
            {
                $upScore++;
                $curY--;
            }
            else
            {
                last;
            }
        }
        $curY = $yCount+1;

        while ($curY <= $treesDown)
        {
            if($height > $trees{"x$xCount"."y$curY"})
            {
                $downScore++;
                $curY++;
            }
            else
            {
                last;
            }
        }
        print "Current Location X:$xCount Y:$yCount\n";
        print "Current Tree Height: ".$trees{"x$xCount"."y$yCount"}."\n";
        print "Right Score: $rightScore\n";
        print "Left Score: $leftScore\n";
        print "Up Score: $upScore\n";
        print "Down Score: $downScore\n";
        print "Total Score:".$rightScore * $leftScore * $upScore * $downScore."\n";

        $scores{"x$xCount"."y$yCount"} = $rightScore * $leftScore * $upScore * $downScore;
        if ($scores{"x$xCount"."y$yCount"} > $maxScore)
        {
            $maxScore = $scores{"x$xCount"."y$yCount"};
        }
        $xCount++;
    }
    $yCount++;
    $xCount= 0;
}

print "Max Score: ".$maxScore."\n";