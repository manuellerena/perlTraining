#!/usr/bin/perl
use strict;
use v5.16;

my $start_run = time();
my $number = shift(@ARGV);
unless ($number =~ /^[+-]?\d+$/){
    die "Wrong input $_";
}

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

my $auxNumber = 1;
my $cant = 0;
while ($auxNumber < $number) {
   if (isPrime($auxNumber)) {
       $cant++;
   }
    $auxNumber +=2;
}
my $end_run = time();
my $run_time = $end_run - $start_run;
print "Job took $run_time seconds\n";
say ("Cant $cant");
#say prime($number);