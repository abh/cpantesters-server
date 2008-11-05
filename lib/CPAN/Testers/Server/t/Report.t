use Test::More qw(no_plan);
use strict;
use warnings;

use_ok('CPANTesters::Report');
use_ok('JSON::XS');
use Data::Dump qw(dump);

my $data = {
            distribution => { version => '1.0',
                              name    => 'Acme-Foo',
                            },
            grade        => 'pass',
            config       => { perl_version => '5.8.8' },
            comments     => "Testing is the awesome.\n\nBlah blah\n",
};

ok(my $report = CPANTesters::Report->new(data => $data), "new");
ok($report->validate, "validate");
ok(my $saved = $report->store, "store");

warn "SAVED: ", dump($saved);


