#! /usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use List::Util qw(sum);
use List::Util qw(any);


open (file,'<',"input_data");
my @hill;
my @start;
my @end;
my %letters;
@letters{("a".."z")} = (1..26);
$letters{'S'} = 0;
$letters{'E'} = 27;


my $maxX=0;
my $y = 0;
while (<file>)
{
    chomp $_;
    my $x=0;
    foreach my $char (split //, $_)
    {
        @{$hill[$y]}[$x]= $char;

        if($char eq 'S')
        {
            @start = ($x,$y);
        }
        elsif ($char eq 'E')
        {
            @end = ($x,$y);
        }
        $x++;
    }
    $maxX = $x;
    $y++;
}
my $maxY = $y;

my @curPos = ($start[0], $start[1]);
my @visited;
@visited[0] = "$curPos[0],$curPos[1]"; #used to track where we've been
my @pathLengths;

print "Start: $start[0],$start[1]\n";
print "End: $end[0],$end[1]\n";
my @queues;
@{$queues[0]}[0]= [$curPos[0], $curPos[1]]; #tracking where we need to go
print Dumper @queues;

#AdjPlaces($curPos[0],$curPos[1],$maxX, $maxY);
while (@queues > 0)
{
    my @path = pop (@queues);
    print "\n======================STEP:".@visited."\n";
    print "Path: ".@{$path[-1]}[0]." ".@{$path[-1]}[1]."\n";
    print Dumper @path;

    #print "Visited Stack: ".$visited[-1]."\n";
    for (AdjPlaces(@{@{$path[-1]}[0]}[0],@{@{$path[-1]}[0]}[0],$maxX, $maxY))
    {
        print "Value to process in loop: ".@{$_}[0]." ".@{$_}[1],"\n";

        my $loc = "@{$_}[0],@{$_}[1]";
        #print "what any returns: ".any {$_ eq $loc} @visited."\n";
       if (ValidMove($letters{@{$hill[@{$_}[1]]}[@{$_}[0]]},$letters{@{$hill[@{@{$path[-1]}[0]}[1]]}[@{@{$path[-1]}[0]}[0]]}) &&
            !(any {$_ eq $loc} @visited))
       {
           #first {$_ eq "@{$_}[0],@{$_}[1]"} @visited == 0
           #grep ($loc, @visited) == 0
           #print "Adj: ".$letters{@{$hill[@{$_}[0]]}[@{$_}[1]]}."\n";
           #print "Cur: ".$letters{@{$hill[@{$path[-1]}[1]]}[@{$path[-1]}[0]]}."\n";
           #print "Valid Move\n";
           my @newQueue;
           @newQueue = @path;
           print "Checking New Queue Data Structure:\n";
           print Dumper @newQueue;
           
           push(@newQueue,[@{$_}[0],@{$_}[1]]);
           if (@{$hill[@{$_}[0]]}[@{$_}[1]] eq "E")
           {
               last;
           }
           else
           {
                push (@visited,"@{$_}[0],@{$_}[1]");
                push (@queues,@newQueue);
           }

       }
    }
}
print "Path found: \n";
print @visited."\n";
print $maxX."\n";
print $maxY."\n";
sub ValidMove
{
    if (abs($_[0] - $_[1]) <= 1)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

sub AdjPlaces
{
    my $x = $_[0];
    my $y = $_[1];
    my $maxX = $_[2];
    my $maxY = $_[3];

    my @adj;

    if(($y-1) >= 0)
    {
        push (@adj, [$x, $y-1]);
    }
    if(($y+1) <= $maxY-1)
    {
        push (@adj,[$x, $y+1]);
    }
    if(0<= ($x - 1))
    {
        push(@adj, [$x-1, $y]);
    }
    if(($x+1) <= $maxX-1)
    {
        push(@adj, [$x+1, $y]);
    }
    return @adj;
}