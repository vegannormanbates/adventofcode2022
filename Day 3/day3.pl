#! /usr/bin/perl
use strict;
use warnings;

open (file,'<',"input_data");
my %priorityItems;
my $bagCount=0;
my @elves;

while (<file>)
{
    chomp $_;
    $elves[$bagCount]=$_;
    $bagCount++;
}
    #my $len = length($_)/2;
    #my $firstSection = substr($_,0,$len);
    #my $secondSection = substr($_,($len),$len);
my $count = 0;
while ($count < $bagCount)
{
    my $commonItem = inBoth($elves[$count],$elves[$count+1],$elves[$count+2]);
    print  "$commonItem\n";
    if (exists($priorityItems{$commonItem}))
    {
        $priorityItems{$commonItem}++;
    }
    else
    {
        $priorityItems{$commonItem}=1;
    }
    $count+=3;
}


my $priorityPoints = 0;

foreach my $key (keys(%priorityItems))
{
    my $keyValue= priority($key);
    $priorityPoints+= $keyValue*$priorityItems{$key};
}

print "Total Priority: $priorityPoints\n";

sub inBoth
{
    my $str1 = $_[0];
    my $str2 = $_[1];
    my $str3 = $_[2];
    my @commonChars;

    foreach my $char (split //,$str1)
    {
        if (index ($str2,$char) >=0)
        {
             if ($str3 eq "")
             {
                 return substr($str2,index ($str2,$char),1);
             }
             else
             {
                 push (@commonChars,substr($str2,index ($str2,$char),1));
             }
        }
    }
    foreach my $char (split //,join("",@commonChars))
    {
        if (index($str3,$char) >= 0)
        {
            return substr($str2,index ($str2,$char),1);
        }
    }
    
}

sub priority
{
    my @lowerCase=("a".."z");
    my @upperCase=("A".."Z");
    my $points;

    if ($_[0] eq lc($_[0]))
    {
        my $count=0;
        foreach my $letter (@lowerCase)
        {
            if ($letter eq $_[0])
            {
                return $count+1;
            }
            else
            {
                $count++;
            }
        }
    }
    else
    {
        my $count=0;
        foreach my $letter (@upperCase)
        {
            if ($letter eq $_[0])
            {
                return $count+27;
            }
            else
            {
                $count++;
            }
        }
    }
}