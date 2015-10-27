#!/usr/bin/perl
use strict;
use v5.16;

my $wordsAsk = "Please, enter space separated strings to match and replace
    (one pair per line) \n Empty line will interrupt input and start execution";
say "Text a sentence to be replaced";
my $sentence = <STDIN>;

say $wordsAsk;
my $replacePair = <STDIN>;
my %replacements;
while ($replacePair ne "\n") {

    my @words = split(' ', $replacePair);
    if (scalar @words == 2) {
        $replacements{@words[0]} = @words[1];
    }
    say $wordsAsk;
    $replacePair = <STDIN>;
}

my $val;
($val = $sentence) =~ s/(@{[join "|", keys %replacements]})/$replacements{$1}/g;
say $val;

exit;