use strict;
use warnings;
use utf8;

package Amon2::Setup::Flavor::Teng;
use parent qw(Amon2::Setup::Flavor);
our $VERSION = '0.01';

sub run {
    my $self = shift;

    $self->write_file('lib/<<PATH>>.pm', <<'...');
package <% $module %>;
use strict;
use warnings;
use utf8;
use parent qw/Amon2/;
our $VERSION='0.01';
use 5.008001;

__PACKAGE__->load_plugin(qw/DBI/);

# initialize database
use DBI;
sub setup_schema {
    my $self = shift;
    my $dbh = $self->dbh();
    my $driver_name = $dbh->{Driver}->{Name};
    my $fname = lc("sql/${driver_name}.sql");
    open my $fh, '<:encoding(UTF-8)', $fname or die "$fname: $!";
    my $source = do { local $/; <$fh> };
    for my $stmt (split /;/, $source) {
        $dbh->do($stmt) or die $dbh->errstr();
    }
}

use Teng;
use Teng::Schema::Loader;
sub db {
    my $self = shift;
    if ( !defined $self->{db} ) {
        my $conf = $self->config->{'DBI'}
        or die "missing configuration for 'DBI'";
        my $dbh = DBI->connect(@{$conf});
        my $schema = Teng::Schema::Loader->load(
            namespace => '<% $module %>::DB',
            dbh       => $dbh,
	    );
        $self->{db} = Teng->new(
            dbh    => $dbh,
            schema => $schema,
	    );
    }
    return $self->{db};
}

1;
...

    $self->write_file('t/08_teng.t', <<'...');
use strict;
use warnings;
use DBI;
use Test::More;
use <% $module %>;

my $dbi = DBI->connect('dbi:SQLite:dbname=db/development.db');
$dbi->do("create table sessions (id char(5) primary key, session_data text)") or die $dbi->errstr;
my $teng = <% $module %>->new;
is(ref $teng, '<% $module %>', 'instance');
is(ref $teng->db, 'Teng', 'instance');
$teng->db->insert('sessions', { id => 'abcde', session_data => 'ka2u' });
my $res = $teng->db->single('sessions', { id => 'abcde' });
is($res->get_column('session_data'), 'ka2u', 'search');

done_testing;
...
}

1;

__END__

=encoding utf-8

=head1 NAME

Amon2::Setup::Flavor::Teng - Teng Flavor for Amon2

=head1 SYNOPSIS

    amon2-setup.pl --flavor Basic,Teng My::App

=head1 DESCRIPTION

Easy setup Teng ORM for Amon2.

=head1 AUTHOR

Kazuhiro Shibuya
