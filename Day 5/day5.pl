#! /usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX;

open (file,'<',"input_data");

my $numStacks=0;
my @stacks;

while(<file>)
{
    chomp $_;
    if (index($_,"move")== -1&& length($_) > 0)
    {
        if(index($_,"[")==-1){next;}

        my $rowLength = length($_);
        my $row = $_;
        my $counter = 0;
        my $itemLocation=0;
        while ($counter < $rowLength)
        {
            $itemLocation = index($row,"[",($itemLocation));
    
            if($itemLocation==0)
            {
                
                push(@{$stacks[0]},substr($row,1,1));
            }
            if($itemLocation>0)
            {
                my $numSpaces = floor($itemLocation/3);
                my $value = $itemLocation - $numSpaces;
                my $column = ceil($value/3);
                push(@{$stacks[$column]},substr($row,($itemLocation+1),1));
            }
            $counter= $itemLocation;
            if($counter == -1){last;}
            $itemLocation++;
        }
    }
    elsif (length($_) == 0)
    {
        my $localCount=0;
        while ($localCount < @stacks)
        {
            @{$stacks[$localCount]}= reverse(@{$stacks[$localCount]});
            $localCount++;
        }
    }
    else
    {
        my @command = split(" ",$_);
        my $numMove = $command[1];
        my $source = $command[3]-1;
        my $dest = $command[5]-1;
        my @crate;
        my $count = 0;
        while ($count < $numMove)
        {
            my $temp = pop(@{$stacks[$source]});
            push(@crate,$temp);
            $count++;
        }
        $count = 0;
        #For part two move the crates into an intermediate array to maintain the order.
        #Remove the second loop and put the push back into the first loop to do part 1.
        while ($count < $numMove)
        {
            my $temp = pop(@crate);
            push(@{$stacks[($dest)]},$temp);
            $count++;
        }
    }
}
my $localCount=0;
while ($localCount < @stacks)
{
    print pop(@{$stacks[$localCount]});
    $localCount++;
}