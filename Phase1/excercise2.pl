#!/usr/bin/perl
use strict;
use v5.16;

#returns 1 if argument is a number bigger than 2 and smaller than 1000000
sub isValidInput {
    my $number = shift;
    unless ($number =~ /\d/) {
        return 0;
    }
    unless ($number >= 2 && $number <= 1000000) {
        return 0;
    }
    return 1;
}

#return 1 if argument number is even 0 if is odd
sub isPrime {
    my $number = shift;
    my $d = 2;
    my $sqrt = sqrt $number;
    while(1) {
        if ($number % $d == 0) {
            return 0;
        }
        if ($d < $sqrt) {
            $d++;
        } else {
            return 1;
        }
    }
}
print "Enter a number: ";
my $number = <STDIN>;
my $startTime = time();
if (isValidInput($number)) {
    my $auxNumber = 1;
    my $cant = 0;
    while ($auxNumber < $number) {
        if (isPrime($auxNumber)) {
            print "$auxNumber ";
            $cant++;
        }
        $auxNumber += 2;
    }
    my $endRun = time();
    my $runTime = $endRun - $startTime;
    say "\nJob took $runTime seconds";
    say "Count $cant";
} else {
    die ('Wrong input');
}
