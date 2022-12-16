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
my $ROW = 2000000; #Defines the row to look in for Part 1.

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