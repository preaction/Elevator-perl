use Module::Build;
use Module::Build;
my $build = Module::Build->new(
    dist_name => 'Elevator',
    dist_version => '1.0',
    module_name => 'Elevator::Base',
    requires => {
        'perl' => '5.10.0',
        'Moo' => 0.85,
        'MooX::Types::MooseLike::Base' => 0,
        'MooX::LvalueAttribute' => 0,
        'strict' => 0,
        'warnings' => 0,
        'Getopt::Long' => 0,
        'Pod::Usage' => 0,
        'File::Slurp' => 0,
    },
    test_requires => {
        'Test::Most' => 0,
        'Capture::Tiny' => 0,
        'File::Spec::Functions' => 0,
        'File::Temp' => 0,
        'FindBin' => 0,
    },
);
$build->create_build_script;
