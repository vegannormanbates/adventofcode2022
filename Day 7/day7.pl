#! /usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use List::Util qw [sum];

open (file,'<',"input_data");
my @path=['/'];
my %sizes;

while(<file>)
{
    chomp $_;
    my @line = split(" ",$_);
    if ($line[0] eq "\$")
    {
        if ($line[1] eq "cd")
        {
            if ($line[2] eq "..")
            {
                pop(@path);
            }
            elsif($line[2] eq "/")
            {
                @path = ("/");
            }
            else
            {
                push(@path,($path[-1]."-".$line[2]));
            }
        }
    }
    if(my ($sizes)= /^([0-9]+)/)
    {
        foreach (@path)
        {
        $sizes{$_} += $sizes;
        }
    }
}
my @dirs = grep ({$_ <= 100000} values %sizes);
print "Part 1: ".sum(@dirs)."\n";

#Part 2
@dirs = values(%sizes);
@dirs = sort {$a <=> $b} @dirs;

foreach my $dir (@dirs)
{
    if((40000000 - $sizes {"/"} + $dir) >= 0)
    {
        print "Part 2: $dir\n";
        last;
    }
}