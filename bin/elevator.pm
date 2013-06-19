#!/usr/bin/env perl
package elevator;
use feature qw( say );
use strict;
use warnings;
use Getopt::Long qw( GetOptionsFromArray );
use Pod::Usage;
use File::Slurp qw( read_file );
use Elevator::A;
use Elevator::B;

sub main {
    my ( $argv ) = @_;
    my %opt;
    GetOptionsFromArray( $argv, \%opt,
        'help|h',
    );
    pod2usage(0) if $opt{help};

    my ( $file, $mode ) = @$argv;
    pod2usage( "ERROR: First argument must be a readable file" ) unless $file && -r $file;
    pod2usage( "ERROR: Second argument must be 'A' or 'B'" ) unless $mode && $mode =~ /^[AB]$/i;

    my $class = "Elevator::" . uc $mode;
    my @runs = process_file( $file );
    for my $run ( @runs ) {
        my $elevator = $class->new( start => $run->{start} );
        $elevator->command( %$_ ) for @{ $run->{commands} };
        $elevator->execute;
        say join " ", @{ $elevator->log }, sprintf '(%i)', $elevator->odometer;
    }

    return 0;
}

# Process a file into an array of hashes containing start floor and a set of
# commands
sub process_file {
    my ( $file ) = @_;
    my @lines = read_file $file;
    my @output;
    for my $line ( @lines ) {
        chomp $line;
        # <start>:<from>-<to>,<from>-<to>,...
        my ( $start, $commands ) = split /:/, $line, 2;
        push @output, {
            start => $start,
            commands => [ 
                map {; { from => $_->[0], to => $_->[1] } }
                map { [ split '-', $_ ] }
                split q{,}, $commands
            ]
        };
    }
    return @output;
}

exit main( \@ARGV ) unless caller(0);

1;

=head1 NAME

elevator.pm - Run an elevator simulation from a file

=head1 SYNOPSIS

    perl elevator.pm <file> <mode>
    perl elevator.pm -h|--help

=head1 ARGUMENTS

=head2 <file>

The path to the file with elevator commands.

=head2 <mode>

The mode for the elevator, either "A" or "B".

=head1 OPTIONS

=head2 help|h

Display help and usage

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Doug Bell <doug.bell@baml.com>

This software may be used and redistributed under the same terms as Perl itself.
