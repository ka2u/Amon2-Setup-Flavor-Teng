use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Amon2::Setup::Flavor::Teng',
    AUTHOR        => 'Kazuhiro Shibuya',
    VERSION_FROM  => 'lib/Amon2/Setup/Flavor/Teng.pm',
    ABSTRACT_FROM => 'lib/Amon2/Setup/Flavor/Teng.pm',
    LICENSE       => 'perl',
    PREREQ_PM     => {
        'Amon2'        => '3.12',
        'Teng'         => '0.12',
        'DBD::SQLite'  => '1.33',
    },
    MIN_PERL_VERSION => '5.008001',
    (-d 'xt' and $ENV{AUTOMATED_TESTING} || $ENV{RELEASE_TESTING}) ? (
        test => {
            TESTS => 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t'
        },
    ) : (),
);
