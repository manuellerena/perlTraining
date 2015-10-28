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
sub distance {

    my $self = shift;
    my ( $point ) = @_;

    return sqrt (($self->{x} - $point->{x})**2 + ($self->{y}-$point->{y})**2);
}
1;

###################################################################
package Figure;
use Geometry::Formula;
use GD::Simple;

    sub new {
        my $class = shift;
        my $self = {
            color=>'',
            coordinates=>[],
            img=>'',
            type=>''
            };
        bless $self, $class;

        return $self;
    }

    sub type {
        my $self = shift;
        if (@_) {
            $self->{type} = shift;
        }
        return $self->{type};
    }

    sub color {
        my $self = shift;
        if (@_) {
            $self->{x} = shift;
        }
        return $self->{x};
    }

    sub add_coordinate {
        my $self = shift;
        my $coordinate = shift;
        my $size =  scalar @{ $self->{coordinates}};
        push( @{ $self->{coordinates} }, $coordinate );
    }

    sub get_coordinates {
        my $self = shift;
        return $self->{coordinates};
    }

    sub pick_color {
        my $self = shift;
        my $color = shift;
        given($color) {
            when ("green") {
               return  $self->{img}->colorAllocate(0, 255, 0);
            }
            when ("blue") {
               return $self->{img}->colorAllocate(0, 0, 255);
            }
            when ("red") {
                return $self->{img}->colorAllocate(255, 0, 0);
            }
            default {
                return $self->{img}->colorAllocate(70,70,70);
            }
        }
    }
    sub create_image{
        my $self = shift;
        $self->{img} = GD::Simple->new(800, 600);

        return $self->{img};
    }
1;
###################################################################
package Figure::Rectangle;
use Geometry::Formula;
use GD::Simple;
#use Figure::Coordinate;

our @ISA = qw(Figure);
sub draw {
    my $self = shift;
    my $coordinates = $self->get_coordinates();
    my $topLeftX = @{$coordinates}[0]->x;
    my $topLeftY = @{$coordinates}[0]->y;

    my $bottomRightX = @{$coordinates}[1]->x;
    my $bottomRightY = @{$coordinates}[1]->y;

    my $img = $self->create_image();;
    $img->bgcolor($self->color());
    $img->rectangle($topLeftX, $topLeftY, $bottomRightX, $bottomRightY);
}

sub calculate_area{
    #my $x   = Geometry::Formula->new;
    my $self = shift;
    my $coordinates = $self->get_coordinates();
    my $topLeftX = @{$coordinates}[0]->x;
    my $topLeftY = @{$coordinates}[0]->y;

    my $bottomRightX = @{$coordinates}[1]->x;
    my $bottomRightY = @{$coordinates}[1]->y;;

    my $heigth = @{$coordinates}[0]->distance(Figure::Coordinate->new
        ($bottomRightX, $topLeftY));

    my $with = @{$coordinates}[1]->distance(Figure::Coordinate->new
        ($topLeftX, $bottomRightY));

    return $heigth * $with;
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

    my $self = shift;
    my $triangle = GD::Polygon->new();

    my $coordinates = $self->get_coordinates();
    my $firstX = @{$coordinates}[0]->x;
    my $firstY = @{$coordinates}[0]->y;

    my $secondX = @{$coordinates}[1]->x;
    my $secondY = @{$coordinates}[1]->y;

    my $thirdX = $firstX + $secondX - (sqrt(3) * ($firstY - $secondY));
    my $thirdY = $firstY + $secondY + (sqrt(3) * ($firstX - $secondX));

    $triangle->addPt(  $firstX,  $firstY);
    $triangle->addPt( $secondX, $secondY);
    $triangle->addPt( $thirdX/2, $thirdY/2);

    my $img = $self->create_image();
    my $color = $self->pick_color($self->color());
    $img->filledPolygon($triangle, $color);
}

sub calculate_area{
    my $self = shift;
    my $coordinates = $self->get_coordinates();
    my $side = @{$coordinates}[0]->distance(@{$coordinates}[1]);
    return ($side * $side * sqrt(3)) / 4;
}
1;
###################################################################
package Figure::Circule;
our @ISA = qw(Figure);
sub draw {

    my $self = shift;
    my $coordinates = $self->get_coordinates();
    my $centerX = @{$coordinates}[0]->x;
    my $centerY = @{$coordinates}[0]->y;

    my $radio = @{$coordinates}[1]->x;

    my $img = $self->create_image();
    my $color = $self->pick_color($self->color());
    $img->filledArc($centerX, $centerY,$radio,
    $radio,0, 360, $color);
}

sub calculate_area {

    my $self = shift;
    my $PI = (4 * atan2(1, 1));
    my $coordinates = $self->get_coordinates();
    my $radio = @{$coordinates}[1]->x;
    return $PI * ($radio**2);
}

1;
###################################################################
package Figure::Command;
use GD::Image;

sub new {
    my $class = shift;
    my $self = {
        figure=>'',
    };
    bless $self, $class;

    return $self;
}

sub figure_factory{

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
    my $figure_type = shift;
    my $color = shift;
    my $figure = $self->figure_factory($figure_type);
    $figure->type($figure_type);
    my @first_coordinate1 = split (',', shift);
    my @second_coordinate1 = split (',', shift);
    $figure->color($color);
    my $coordinate = Figure::Coordinate->new($first_coordinate1[0],$first_coordinate1[1]);
    my $coordinate1 = Figure::Coordinate->new($second_coordinate1[0],$second_coordinate1[1]);

    $figure->add_coordinate($coordinate);
    $figure->add_coordinate($coordinate1);
    $figure->draw();


    open my $out, '>', "figures/$figure_type-$color.png" or die;
    binmode $out;
    print $out $figure->{img}->png;
    my $persistence = Figure::Persistence->new();
    $persistence->saveFigure($figure);
    exit $figure->calculate_area();
}
1;
###################################################################
package Figure::Persistence;
use DBI;

sub new {
    my $class = shift;
    my $self = {
        figure=>'',
        dbh=>''
    };
    bless $self, $class;
    my $dsn = "DBI:mysql:database=perl_training;host=localhost;port=3306";
    $self->{dbh} = DBI->connect($dsn, 'root', 'root') or die $DBI::errstr;

    my $createString = "CREATE TABLE IF NOT EXISTS figures
        ( `id` INT( 255 ) NOT NULL AUTO_INCREMENT ,
        `type` VARCHAR( 10 ) NOT NULL ,
        `color` VARCHAR( 10 ) NOT NULL ,
        `coordinates` VARCHAR( 255 ) NOT NULL ,
        INDEX (type),
        PRIMARY KEY ( `id` )) ";
    my $statment = $self->{dbh}->do($createString)
        or die "Could  not prepare sql statement";
    return $self;
}

sub saveFigure {
    my $self = shift;
    my $figure = shift;
    my $insertString = "INSERT INTO figures VALUES (null, ?, ?, ?)";
    my $sth = $self->{dbh}->prepare($insertString)
        or die "Couldn't prepare statement: " . $self->{dbh}->errstr;

    my $coordinates = $figure->get_coordinates();
    my $firstX = @{$coordinates}[0]->x;
    my $firstY = @{$coordinates}[0]->y;

    my $secondX = @{$coordinates}[1]->x;
    my $secondY = @{$coordinates}[1]->y;
    $sth->excecute($figure->type(), $figure->color(), "$firstX,$firstY
        $secondX,$secondY");
        #or die "Couldn't execute statement: " . $self->{dbh}->errstr;
}

sub listFiguresByType {
    my $self = shift;
    my $type = shift;

    my $queryString = "SELECT * FROM figures WHERE type = ?";
    my $sth = $self->{dbh}->prepare($queryString)
        or die "Couldn't prepare statement: " . $self->{dbh}->errstr;

    $sth->excecute($type)
        or die "Couldn't execute statement: " . $self->{dbh}->errstr;

    return $sth;
}
1;


my $command = Figure::Command->run('triangle', 'blue', '100,300', '150,300');
