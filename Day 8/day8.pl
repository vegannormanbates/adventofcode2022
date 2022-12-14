#! /usr/bin/perl
use strict;
use warnings;

open (file,'<',"input_data");
my %trees; #Using a hash was a terrible idea.
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