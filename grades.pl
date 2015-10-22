#!/usr/bin/perl
use v5.14;

open(GRADES, "<:utf8", "grades") || die "Cant't open grades: $!\n";
binmode(STDOUT, ':utf8');
my %grades;
while (my $line = <GRADES>) {
    my ($student, $grade) = split (" ", $line);
    $grades{$student} .= $grade . " ";
}

for my $student (sort keys %grades) {
    my $scores = 0;
    my $total = 0;
    my @grades = split(" ", $grades{$student});
    for my $grade (@grades) {
        $total += $grade;
        $scores++;
    }
    my $average = $total / $scores;
    print "$student: $grades{$student}\t Average: $average\n";
}

my $value = 26;
given($value){
    when($value > 26){
        say "Es mayor a 0";
    }
    when([25,26,27]){
        say "Es mayor 25,26,27";
    }

    default {
        say "puta madre";
    }
}