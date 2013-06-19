package Elevator::A;
use Moo;

# Using extends becaue MooX::LvalueAccessor requires it
# and lvalue subs make the code look a lot better
extends 'Elevator::Base';

sub execute {
    my ( $self ) = @_;
    push @{ $self->log }, $self->current;
    for my $command ( @{ $self->pending } ) {
        for my $floor ( @{ $command }{qw( from to )} ) {
            next if $floor == $self->current;
            $self->odometer += abs( $self->current - $floor );
            push @{ $self->log }, $floor;
            $self->current = $floor;
        }
    }
}

1;
__END__

=head1 NAME

Elevator::A - The inefficient, lonely elevator

=head1 DESCRIPTION

This implementation of an elevator allows for one passenger at a time
and carries that passenger to their destination immediately.

=head1 SEE ALSO

=over 4

=item Elevator::Base

=back

