#!/usr/bin/perl
use strict;
use v5.16;
no warnings 'experimental::smartmatch';
use GD::Simple;
use Data::Dumper;

package Figure::Coordinate;

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    if (@_) {
        $self->{x} = shift;
        $self->{y} = shift;
    }
    return $self;
}
sub x {
    my $self = shift;
    if (@_) {
        $self->{x} = shift;
    }
    return $self->{x};
}
sub y {
    my $self = shift;
    if (@_) {
        $self->{y} = shift;
    }
    return $self->{y};
}
1;

###################################################################
package Figure;

    sub new {
        my $class = shift;
        my $self = {
            colour=>'',
            coordinates=>[]
            };
        bless $self, $class;

        return $self;
    }

    sub colour {
        my $self = shift;
        if (@_) {
            $self->{x} = shift;
        }
        return $self->{x};
    }

    sub addCoordinate {
        my $self = shift;
        my $coordinate = shift;
        my $size =  scalar @{ $self->{coordinates}};
            say $size;
        push( @{ $self->{coordinates} }, $coordinate );
    }

    sub getCoordinates {
        my $self = shift;
        return $self->{coordinates};
    }
1;
###################################################################
package Figure::Rectangle;
use GD::Simple;

our @ISA = qw(Figure);
sub draw {
    my $self = shift;
    my $coordinates = $self->getCoordinates();
    my $topLeftX = @{$coordinates}[0]->x;
    my $topLeftY = @{$coordinates}[0]->y;

    my $bottomRightX = @{$coordinates}[1]->x;
    my $bottomRightY = @{$coordinates}[1]->y;

    my $img = GD::Simple->new(800, 600);
    $img->bgcolor($self->colour());
    $img->rectangle($topLeftX, $topLeftY, $bottomRightX, $bottomRightY);
    open my $out, '>', 'img.png' or die;
    binmode $out;
    print $out $img->png;
    say "Dray Rectangle";
}
sub validateCoordinate{
    return 1;
}

sub calculateArea{
    return 10;
}
1;
###################################################################
package Figure::Square;
our @ISA = qw(Figure::Rectangle);

sub validateCoordinate{
    return 1;
}
1;
###################################################################
package Figure::Triangle;
use GD::Polygon;
use GD::Image;
our @ISA = qw(Figure);
sub draw {

    my $triangle = GD::Polygon->new();

    $triangle->addPt(  50,  100);
    $triangle->addPt( 100, 50);
    $triangle->addPt( 130, 130);

    #$triangle->offset(250,50);

    my $img = GD::Image->new(800, 600);
    my $white = $img->colorAllocate(255,255,255);
    my $blue = $img->colorAllocate(0,0,255);
   # $img->transparent($white);
    $img->filledPolygon($triangle, $blue);
    open my $out, '>', 'Triangle.png' or die;
    binmode $out;
    print $out $img->png;
    say "Dray triangle";

}
sub validateCoordinate{
    return 1;
}

sub calculateArea{
    return 10;
}
1;
###################################################################
package Figure::Circule;
our @ISA = qw(Figure);
sub draw {

    my $self = shift;
    my $coordinates = $self->getCoordinates();
    my $topLeftX = @{$coordinates}[0]->x;
    my $topLeftY = @{$coordinates}[0]->y;

    my $bottomRightX = @{$coordinates}[1]->x;
    my $bottomRightY = @{$coordinates}[1]->y;

    my $img = GD::Simple->new(800, 600);
    my $white = $img->colorAllocate(255,255,255);
    my $blue = $img->colorAllocate(255,0,255);
    my $red = $img->colorAllocate(255,0,0);
    #$img->transparent($white);
    $img->bgcolor($blue);
    $img->filledArc(400,300,190,190,0,360, $red);
    #$img->fill(150,150,$red);
    open my $out, '>', 'Circle.png' or die;
    binmode $out;
    print $out $img->png;
    say "Dray Circle";
}
sub validateCoordinate{
    return 1;
}

sub calculateArea{
    return 10;
}
1;
###################################################################
package Figure::Command;

sub new {
    my $class = shift;
    my $self = {
        figure=>'',
    };
    bless $self, $class;

    return $self;
}

sub figureFactory{

    my $self = shift;
    my $figureType = shift;
    given ($figureType) {
        when ("rectangle") {
            return Figure::Rectangle->new();
        }
        when ("square"){
            return Figure::Square->new();
        }
        when ("circle") {
            return Figure::Circule->new();
        }
        when ("triangle") {
            return Figure::Triangle->new();
        }
        default{
            exit("Unknow figure type $figureType");
        }
    }
}

sub run{
    my $self = shift;
    my $figure = $self->figureFactory(shift);
    $figure->colour('red');
    my $coordinate = Figure::Coordinate->new(160,160);
    my $coordinate1 = Figure::Coordinate->new(50,50);

    $figure->addCoordinate($coordinate);
    $figure->addCoordinate($coordinate1);
    $figure->draw();
    say $figure->calculateArea();
}
1;

my $command = Figure::Command->run('circle');

#my $coordinate4 = Figure::Coordinate->new(4,3);
#my $figure = Figure::Rectangle->new();
#$figure->addCoordinate($coordinate);
#$figure->addCoordinate($coordinate1);
#$figure->addCoordinate($coordinate4);

#say(scalar @{$figure->{coordinates}});
