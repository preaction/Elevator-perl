
use Test::Most;
use Capture::Tiny qw( capture );
use File::Temp qw( tempfile );
use File::Slurp qw( write_file );
use FindBin qw( $Bin );
use File::Spec::Functions qw( catdir updir );
use lib catdir( $Bin, updir(), 'bin' );
use elevator;

# First, write out the file we have to read
my $tmp = File::Temp->new;
print $tmp <<END_INPUT;
10:8-1
9:1-5,1-6,1-5
2:4-1,4-2,6-8
3:7-9,3-7,5-8,7-11,11-1
7:11-6,10-5,6-8,7-4,12-7,8-9
6:1-8,6-8
END_INPUT

subtest 'validate file' => sub {
    # Calling system here because pod2usage calls "exit"
    my ( $stdout, $stderr, $exit ) = capture {
        return system 'perl', $INC{'elevator.pm'};
    };
    isnt $exit, 0, 'failure';
    like $stderr, qr/^ERROR:/, 'error occurred';
    like $stderr, qr/must be a readable file/, '... because the file was missing';
};

subtest 'validate mode' => sub {
    # Calling system here because pod2usage calls "exit"
    my ( $stdout, $stderr, $exit ) = capture {
        return system 'perl', $INC{'elevator.pm'}, "$tmp";
    };
    isnt $exit, 0, 'failure';
    like $stderr, qr/^ERROR:/, 'error occurred';
    like $stderr, qr/must be 'A' or 'B'/, '... because the mode was missing';
};

subtest 'mode_a' => sub {
    my ( $stdout, $stderr, $exit ) = capture {
        elevator::main( [ "$tmp", "A" ] );
    };
    is $exit, 0, 'success';
    ok !$stderr, 'no errors or warnings';
    eq_or_diff $stdout, <<'OUTPUT';
10 8 1 (9)
9 1 5 1 6 1 5 (30)
2 4 1 4 2 6 8 (16)
3 7 9 3 7 5 8 7 11 1 (36)
7 11 6 10 5 6 8 7 4 12 7 8 9 (40)
6 1 8 6 8 (16)
OUTPUT
};

subtest 'mode_b' => sub {
    my ( $stdout, $stderr, $exit ) = capture {
        elevator::main( [ "$tmp", "B" ] );
    };
    is $exit, 0, 'success';
    ok !$stderr, 'no errors or warnings';
    eq_or_diff $stdout, <<'OUTPUT';
10 8 1 (9)
9 1 5 6 (13)
2 4 2 1 6 8 (12)
3 5 7 8 9 11 1 (18)
7 11 10 6 5 6 8 12 7 4 8 9 (30)
6 1 6 8 (12)
OUTPUT
};

done_testing;
