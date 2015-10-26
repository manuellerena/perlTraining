#!/usr/bin/perl
use strict;
use v5.16;
use Lingua::EN::Words2Nums;

my $fileName = 'words';
open INFILE, "$fileName";
my @data = <INFILE> ;
close INFILE;

my %numbersAndWords;
foreach (@data) {
    #remove \n
    $_ =~ s/\n+$//;

    my $word =  $_;
    my $number = words2nums($word);
    $numbersAndWords{$number} = $word;
}

foreach my $number (sort {$a <=> $b} keys %numbersAndWords) {
    printf "%-8s %s\n", $number, $numbersAndWords{$number};
}