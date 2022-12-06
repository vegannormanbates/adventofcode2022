#! /usr/bin/perl
use strict;
use warnings;

open (file,'<',"input_data");
my @chars;

while(<file>)
{
    chomp $_;
    my @charArray = split('',$_);
    foreach my $letter (@charArray)
    {    
        if ($#chars==-1)
        {
            push(@chars,$letter);
        }
        elsif( $#chars >= 0 && $#chars < 13)
        {
            if(grep(/$letter/,@chars))
            {
                shift(@chars);
                while (grep(/$letter/,@chars))
                {
                    shift(@chars);
                }
                push(@chars,$letter);
            }
            else
            {
                push(@chars,$letter);
            }
        }
        if($#chars == 13)
        {
            print "Unique Code: @chars\n";
            my $location = index($_, join('',@chars))+14;
            print "indexed at $location\n";
            last;
        }
    }
    

}