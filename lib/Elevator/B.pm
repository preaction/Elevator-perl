package Elevator::B;
use Moo;
use List::MoreUtils qw( uniq );

extends 'Elevator::A';

# Returns true if the given command is going up
sub is_up($) {
    my ( $command ) = @_;
    return $command->{from} < $command->{to};
}

sub command {
    my ( $self, %command ) = @_;
    my $up = is_up \%command;

    # Explicitly define our implied starting command
    unless ( @{ $self->pending } ) {
        push @{ $self->pending }, { from => $self->start, to => $command{from} };
    }

    # Look backwards through our commands to see if we can reorganize them
    my @re = ();
    while ( @{ $self->pending } ) {
        # If we switch direction, we can't reorganize any more
        last if $up != is_up $self->pending->[-1];
        push @re, pop @{ $self->pending };
    }
    push @re, \%command;

    # Reorganize the commands we found to be more efficient
    if ( @re > 1 ) {
        # Since we're all going the same direction, we can just sort the list
        # of unique destinations
        my @sorted = sort { $a <=> $b } uniq map { values %$_ } @re;
        unless ( is_up $re[0] ) {
            # We're going down
            @sorted = reverse @sorted;
        }
        # If we have to travel to floors 1, 3, 4, 7, we need to have commands
        # for 1 -> 3, 3 -> 4, 4 -> 7
        @re = map {; { from => $sorted[$_], to => $sorted[$_+1] } }
              0..$#sorted-1
    }

    push @{ $self->pending }, @re;
}


1;
__END__

=head1 NAME

Elevator::B - A more efficient elevator

=head1 DESCRIPTION

This class implements a far more efficient elevator. Any adjacent commands going in
the same direction are performed together.

=head1 SEE ALSO

=over 4

=item Elevator::A

=item Elevator::Base

=back

