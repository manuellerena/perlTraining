#!/usr/bin/perl
use strict;
use v5.16;

my $a = shift(@ARGV) || 0;
my $b = shift(@ARGV) || 0;
my $c = shift(@ARGV) || 0;
my @inputs = ($a, $b, $c);

foreach (@inputs) {
    unless (($_ =~ /^[+-]?\d+$/) || ( $_ =~ /^([+-]?)(?=\d|\.\d)\d*(\.\d*)?([Ee]([+-]?\d+))?$/)){
       die "Wrong input $_";
    }
}
my $sqrt = $b * $b - 4 * $a * $c;

if ($a > 0 && $sqrt > 0) {
    my $x1 = (-$b + sqrt($sqrt)) / 2 * $a;
    my $x2 = (-$b - sqrt($sqrt)) / 2 * $a;
    say "$x1 $x2";
    exit;
} elsif($a == 0 && $b != 0) {
    say (-$c/$b);
} else {
    die "No real solution\n" ;
}


