package Elevator::Base;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);
use MooX::LvalueAttribute;

has start => (
    is  => 'ro',
    isa => Int,
    required => 1,
);

has current => (
    is  => 'rw',
    isa => Maybe[Int],
    default => sub { $_[0]->start },
    lazy => 1,
    lvalue => 1,
);

has pending => (
    is  => 'rw',
    isa => ArrayRef[ HashRef ],
    default => sub { [] },
);

has log => (
    is  => 'rw',
    isa => ArrayRef[ Int ],
    default => sub { [] },
);

has odometer => (
    is  => 'rw',
    isa => Int,
    lvalue => 1,
    default => 0,
);

sub command {
    my ( $self, %command ) = @_;
    push @{ $self->pending }, \%command;
}

1;
__END__

=head1 NAME

Elevator::Role - An elevator simulator

=head1 SYNOPSIS

    package Elevator;
    use Moo;
    with 'Elevator::Role';
    my $elevator = Elevator->new( start => 1 );

=head1 ATTRIBUTES

=head2 start

The starting floor for the elevator. Required.

=head2 current

The current floor the elevator is on. Defaults to the start floor.

=head2 pending

The list of pending commands, waiting for execute().

=head2 log

The log of floors travelled to.

=head2 odometer

The number of floors travelled by the elevator.

=head1 METHODS

=head2 command( from => $floor, to => $floor )

Add a command to the elevator. Commands are queued in the C<pending> array until
execute() is called.

=head2 execute()

Execute the pending commands, adding to the C<log> and C<odometer>.

