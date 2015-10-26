#!/usr/bin/perl
use strict;
use v5.16;
use Paths::Graph;

my $fileName = 'paths';
open INFILE, "$fileName";
my @data = <INFILE> ;
close INFILE;

my %graph;
my $origin;
my $destiny;
my $iteration = 1;

foreach (@data) {
    #remove \n
    $_ =~ s/\n+$//;
    my @nodes = split / /, $_;

    if ($iteration == 1) {
        $origin = $nodes[0];
        $destiny = $nodes[1]
    } else {
        $graph{$nodes[0]}{$nodes[1]} = 1;
    }
    $iteration++;
}
my $obj = Paths::Graph->new(-origin=>$origin,-destiny=>$destiny,-graph=>\%graph);

my @paths = $obj->shortest_path();

my $path = shift @paths;
my $cost = $obj->get_path_cost(@$path);
if ($cost > 0) {
    print $cost;
} else {
    print -1;
}
exit;
