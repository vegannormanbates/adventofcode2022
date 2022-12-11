#! /usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use List::Util qw(sum);

open (file,'<',"input_data");
my $numMonkeys= -1;

#Variables for making monkeys
my @starting_items;
my @operator;
my @opValue;
my @test;
my @ifTrue;
my @ifFalse;

while(<file>)
{
    $_ =~ s/^\s+//;
    my @line = split(' ',$_);

    if (@line == 0)
    {
        next;
    }

    if ($line[0] eq "Monkey")
    {
        $numMonkeys++;
    }
    elsif ($line[0] eq "Starting")
    {
        my $numItems = (scalar @line) -2;
        my $count = 2;
        my @items;
        while ($count < (scalar @line))
        {
            my $item = $line[$count];
            $item =~ s/\,$//;
            push(@items, $item);
            $count++;
        }
        @{$starting_items[$numMonkeys]} = @items;
    }
    elsif ($line[0] eq "Operation:")
    {
        $operator[$numMonkeys] = $line[4];
        $opValue[$numMonkeys] = $line[5];
    }
    elsif ($line[0] eq "Test:")
    {
        $test[$numMonkeys] = $line[3];
    }
    elsif ($line[1] eq "true:")
    {
        $ifTrue[$numMonkeys] = $line[5];
    }
    elsif ($line[1] eq "false:")
    {
        $ifFalse[$numMonkeys] = $line[5];
    }
}
my $numRounds = 10000;
my $curRound = 0;
my @itemsInspected;
my $lcm =1;
$lcm *= $_ for @test;

while ($curRound < $numRounds)
{
    my $curMonkey = 0;
    while ($curMonkey <= $numMonkeys)
    {
            while (my $item = shift (@{$starting_items[$curMonkey]}))
            {
                $itemsInspected[$curMonkey]+=1;
                my $opValue;
                if ($operator[$curMonkey] eq '*')
                {
                    if($opValue[$curMonkey] eq 'old')
                    {
                        $opValue = $item;
                    }
                    else
                    {
                        $opValue = $opValue[$curMonkey];
                    }

                    $item = $item * $opValue;
                }
                elsif ($operator[$curMonkey] eq "+")
                {
                    $item = $item + $opValue[$curMonkey];
                }

                $item = int($item% $lcm); #for part one change to this /3 instead of %$lcm

                if ($item % $test[$curMonkey] == 0)
                {
                    my $target = $ifTrue[$curMonkey];
                    push(@{$starting_items[$target]},$item);
                }
                else
                {
                    my $target = $ifFalse[$curMonkey];
                    push(@{$starting_items[$target]},$item);
                }
            }
        $curMonkey++;
    }
    $curRound++;
}
@itemsInspected =  sort {$b <=> $a} @itemsInspected;
my $topSum = $itemsInspected[0] * $itemsInspected[1];
print "Answer: $topSum\n";