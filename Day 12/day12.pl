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
#@visited[0] = "$curPos[0],$curPos[1]"; #used to track where we've been
my @pathLengths;

print "Start: $start[0],$start[1]\n";
print "End: $end[0],$end[1]\n";
my @queues;
@{$queues[0]}[0]= "$curPos[0],$curPos[1]"; #tracking where we need to go

#AdjPlaces($curPos[0],$curPos[1],$maxX, $maxY);
while (@queues > 0)
{
    my @path = shift (@queues);
    my ($x,$y) = split(',',@{$path[-1]}[-1]);
    print "\n======================STEP:".@visited."\n";
    #print Dumper @path;
    print Dumper @queues;

    print "Current Coord: $x,$y\n";
    if (@{$hill[$y]}[$x] eq "E")
    {
        print "DESTINATION FOUND:\n";
        last;
    }
    for (AdjPlaces($x,$y,$maxX, $maxY))
    {
        #print "Value to process in loop: ".@{$_}[0]." ".@{$_}[1],"\n";

        my $loc = "@{$_}[0],@{$_}[1]";
        #print "CURRENT LETTER: ".@{$hill[@{$_}[1]]}[@{$_}[0]]."\n";
       if (ValidMove($letters{@{$hill[@{$_}[1]]}[@{$_}[0]]},$letters{@{$hill[$y]}[$x]}) &&
            !(any {$_ eq $loc} @visited))
        {
            #my @newQueue = @path;
            push(@{$path[-1]},"@{$_}[0],@{$_}[1]");
            print "Path after adding most recent location:\n".Dumper @path;
            my $current_letter = @{$hill[@{$_}[1]]}[@{$_}[0]];
            if ($current_letter eq "E")
            {
                print "Path found: \n";
                print @visited."\n";
                #print @newQueue."\n";
                last;
            }
            else
            {
                push (@visited,("@{$_}[0],@{$_}[1]"));
                push (@{$queues},@path);

            }
       }
    }
}
print "Path found: \n";
print @visited."\n";

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

    if(($y+1) <= $maxY-1)
    {
        push (@adj,[$x, $y+1]);
    }
    if(($y-1) >= 0)
    {
        push (@adj, [$x, $y-1]);
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