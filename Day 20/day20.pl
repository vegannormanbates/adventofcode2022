#! /usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(first_index);

open (file,'<',"input_data");

my @code;
my $count = 0;
my $zero; #index of zero

#party 2 silliness
my $key = 811589153;
my $numMix = 10;

while(<file>)
{
    chomp $_;
    my $num = $_ * $key;
    my $unique = $num.",$count";
    push(@code, $num.",$count");
    if($_ eq '0')
    {
        $zero = $unique;
    }
    $count++;
}
print "Number of Elements: $count\n";
my @codeCopy = @code;
my $n = 1;
while ($n <= 10)
{
    print "ITERATION NUMBER: $n\n";
    foreach my $num (@codeCopy)
    {
        start($num,\@code);
        my $removed = shift(@code); #remove the element we just moved to 0.
        my $number = getNum($num);
        rotate($number, \@code);
        unshift(@code, $removed);
    }
    $n++;
}
start($zero,\@code);

my $val1 = getNum($code[1000 % $count]);
my $val2 = getNum($code[2000 % $count]);
my $val3 = getNum($code[3000 % $count]);
my $sum = $val1 + $val2 + $val3;
print "KEY VALUES: $val1, $val2, $val3\n";
print "SUM: $sum\n";

sub rotate
{
    my $jump = $_[0]; #number of places to move
    my $code = $_[1]; #reference to the @code
    $jump %= @$code; #if the distance we have to move is longer than the list
    my @moved = splice (@$code, 0, $jump);
    push (@$code, @moved);
}
# Need to rotate to the correct element.
sub start
{
    my $num = $_[0];
    my $code = $_[1]; #reference to the code
    my $index = first_index { $_ eq $num } @$code;
    rotate($index, $code);
}
# when iterating through the list multiple times duplicates become a problem. trying to combine the original index to make each
# number unique.
sub getNum
{
    my $num = $_[0];
    $num =~ s/,.*//;
    return $num;
}