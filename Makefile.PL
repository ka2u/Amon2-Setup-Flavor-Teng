use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Amon2::Setup::Flavor::Teng',
    AUTHOR        => 'Kazuhiro Shibuya',
    VERSION_FROM  => 'lib/Amon2/Setup/Flavor/Teng.pm',
    ABSTRACT_FROM => 'lib/Amon2/Setup/Flavor/Teng.pm',
    LICENSE       => 'perl',
    PREREQ_PM     => {
        'Amon2'              => '3.53',
        'Åmon2::Plugin::DBI' => '0.08',
        'Teng'               => '0.15',
        'DBD::SQLite'        => '1.37',
    },
    MIN_PERL_VERSION => '5.008001',
    (-d 'xt' and $ENV{AUTOMATED_TESTING} || $ENV{RELEASE_TESTING}) ? (
        test => {
            TESTS => 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t'
        },
    ) : (),
);
