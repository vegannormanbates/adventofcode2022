#! /usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);

my @sensors;
my $startTime = time();
open (file,'<',"input_data");

#Read File and Create Sensor Hashes
while (<file>)
{
    chomp($_);
    $_ =~ /Sensor at x=(\-?\d+), y=(\-?\d+): closest beacon is at x=(\-?\d+), y=(\-?\d+)/;
    my %sensor = (
        sensorX => $1,
        sensorY => $2,
        beaconX => $3,
        beaconY => $4
    );
    my $distance = abs($sensor{'sensorX'} - $sensor{'beaconX'}) + abs($sensor{'sensorY'} - $sensor{'beaconY'});
    push(@sensors, { sensorX => $1,
        sensorY => $2,
        beaconX => $3,
        beaconY => $4,
        distance=> $distance});
}
my @blocked;
my $ROW = 10; #Defines the row to look in for Part 1. Full data: 2000000 Sample: 10

#Part 1 Finds all the points in the defined row blocked by a sensor
foreach my $sensor (@sensors)
{
    my $inRange = 0;
    my $xRange = ${$sensor}{'sensorX'} - ${$sensor}{'distance'};
   while (${$sensor}{'sensorX'} - ${$sensor}{'distance'} <= $xRange && $xRange <= ${$sensor}{'sensorX'} + ${$sensor}{'distance'})
   {
        $inRange = withinRange(${$sensor}{'sensorX'},${$sensor}{'sensorY'},$xRange,$ROW,${$sensor}{'distance'});
        if( $inRange > 0 && ${$sensor}{'beaconX'} == $xRange && ${$sensor}{'beaconY'}==$ROW)
        {
            $inRange--;
        }
        elsif ($inRange > 0)
        {
            push(@blocked,$xRange);
        }
        $xRange++;
    }
}
my $runTime = time() - $startTime;
print "Part 1: ".uniq(@blocked)."\n";
print "Part 1 Runtime: $runTime seconds\n";

$startTime = time();

#for part 2 need to find all the points 1 unit outside of each sensor. Then check if any of those are also out of range of
#all other sensors.
#beacon must have x and y coordinates each no lower than 0 and no larger than 4000000
my $minX = 0;
my $maxX = 4000000;
my $minY = 0;
my $maxY = 4000000;
my @poi;
my $tuningFreq = 0;
foreach my $sensor (@sensors)
{
    @poi = borderPoints(${$sensor}{'sensorX'},${$sensor}{'sensorY'},${$sensor}{'distance'});
    print length \@poi," Points to check\n";
    print Dumper \@poi;
    foreach my $point (@poi)
    {
        my $inRange = 0;
        if (${$point}{'x'} > $maxX || ${$point}{'x'} < $minX || ${$point}{'y'} > $maxY ||${$point}{'y'} < $minY)
        {
            next;
        }
        else
        {
            foreach my $sensor (@sensors)
            {
                $inRange += withinRange(${$sensor}{'sensorX'},${$sensor}{'sensorY'},${$point}{'x'},${$point}{'y'},${$sensor}{'distance'});
            }
            if($inRange == 0)
            {
                print "Point Found: X->${$point}{'x'} Y->${$point}{'y'}\n";
                $tuningFreq = (${$point}{'x'} *4000000) + ${$point}{'y'};
                last;
            }
        }
    }
    if($tuningFreq > 0)
    {
        last;
    }
}
#determine its tuning frequency, which can be found by multiplying its x coordinate by 4000000 and then adding its y coordinate

$runTime = time() - $startTime;
print "Part 2: $tuningFreq\n";
print "Part 2 Runtime: $runTime seconds\n";

sub withinRange
{
    my $sensorX = $_[0];
    my $sensorY = $_[1];
    my $testX = $_[2];
    my $testY = $_[3];
    my $distance = $_[4];
    if( (abs($sensorX - $testX) + abs($sensorY - $testY)) <= $distance)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

sub borderPoints
{
    my $sensorX = $_[0];
    my $sensorY = $_[1];
    my $distance = $_[2]+1; #+1 to be 1 unit outside of range
    my @points;

    my $right = $sensorX + $distance;
    my $left = $sensorX - $distance;
    my $middle = $left + (($right - $left)/2);
    my $bottom = $sensorY + $distance;
    my $top = $sensorY - $distance;

    foreach my $xCoord ($left..$right)
    {
        my $yMod = abs($xCoord - $middle);
        push(@points, {x=>$xCoord, y=>($top-$yMod)});
        push(@points, {x=>$xCoord, y=>($bottom+$yMod)});
    }
    return @points;
}