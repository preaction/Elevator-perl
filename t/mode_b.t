
use Test::Most qw( die );
use Elevator::B;

subtest 'input line 1' => sub {
    my $elevator = Elevator::B->new( start => 10 );
    $elevator->command( from => 8, to => 1 );
    $elevator->execute;
    cmp_deeply $elevator->log, [qw( 10 8 1 )]
        or diag explain $elevator->log;
    is $elevator->odometer, 9;
};

subtest 'input line 2' => sub {
    my $elevator = Elevator::B->new( start => 9 );
    $elevator->command( from => 1, to => 5 );
    $elevator->command( from => 1, to => 6 );
    $elevator->command( from => 1, to => 5 );
    $elevator->execute;
    cmp_deeply $elevator->log, [qw( 9 1 5 6 )]
        or diag explain $elevator->log;
    is $elevator->odometer, 13;
};

subtest 'input line 3' => sub {
    my $elevator = Elevator::B->new( start => 2 );
    $elevator->command( from => 4, to => 1 );
    $elevator->command( from => 4, to => 2 );
    $elevator->command( from => 6, to => 8 );
    $elevator->execute;
    cmp_deeply $elevator->log, [qw( 2 4 2 1 6 8 )];
    is $elevator->odometer, 12;
};

subtest 'input line 4' => sub {
    my $elevator = Elevator::B->new( start => 3 );
    $elevator->command( from => 7, to => 9 );
    $elevator->command( from => 3, to => 7 );
    $elevator->command( from => 5, to => 8 );
    $elevator->command( from => 7, to => 11 );
    $elevator->command( from => 11, to => 1 );
    $elevator->execute;
    cmp_deeply $elevator->log, [qw( 3 5 7 8 9 11 1 )];
    is $elevator->odometer, 18;
};

subtest 'input line 5' => sub {
    my $elevator = Elevator::B->new( start => 7 );
    $elevator->command( from => 11, to => 6 );
    $elevator->command( from => 10, to => 5 );
    $elevator->command( from => 6, to => 8 );
    $elevator->command( from => 7, to => 4 );
    $elevator->command( from => 12, to => 7 );
    $elevator->command( from => 8, to => 9 );
    $elevator->execute;
    cmp_deeply $elevator->log, [qw( 7 11 10 6 5 6 8 12 7 4 8 9 )];
    is $elevator->odometer, 30;
};

subtest 'input line 6' => sub {
    my $elevator = Elevator::B->new( start => 6 );
    $elevator->command( from => 1, to => 8 );
    $elevator->command( from => 6, to => 8 );
    $elevator->execute;
    cmp_deeply $elevator->log, [qw( 6 1 6 8 )];
    is $elevator->odometer, 12;
};

done_testing;
