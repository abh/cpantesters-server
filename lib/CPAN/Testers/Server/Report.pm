package CPANTesters::Report;
# TODO: rename to CPANTesters::ReportStore ?

use strict;
use warnings;

use lib '/Users/ask/src/Net-CouchDb/lib/';

use Net::CouchDb;
use LWP::ConnCache;
use Data::Dump qw(dump);

# http://localhost:5984/cpantesters/_view/dist/name?key=%22Acme-Foo%22 

my $conn_cache = LWP::ConnCache->new;

my $couch = Net::CouchDb->new(host       => 'localhost',
                            conn_cache => $conn_cache,
                           );

my $cdb = $couch->db("cpantesters");

sub new {
    my ($class, %args) = @_;
    my $id = $args{id};

    # get couchdb rev
    if ($id) {
        # load data from store
    }

    my $data = $args{data};

    $data->{type} = 'report';

    bless $data, $class;
}

sub validate {
    my $self = shift;

    my $errors = {};

    for my $f (qw(distribution grade config)) {
        next if $self->{$f};
        $errors->{$f} = "Field required";
    }

    unless ($errors->{grade}) {
        $self->{grade} = lc $self->{grade};
        $errors->{grade} = "Invalid grade"
          unless $self->{grade} =~ m/^(pass|fail|unknown|na)$/
    }
    
    for my $f (qw(distribution config)) {
        unless ($errors->{$f}) {
            $errors->{$f} = "Must be a hash"
              unless ref $self->{$f} eq 'HASH';
        }
    }
        

    unless ($errors->{distribution}) {
        for my $f (qw(name version)) {
            next if $self->{distribution}->{$f};
            $errors->{distribution}->{$f} = "Field required";
        }
    }

    $self->{comments} ||= '';

    # TODO: verify "submitted_by"

    $self->{_errors} = %$errors ? $errors : undef;

    warn "ERRORS: ", dump($errors);

    $self->{_errors} ? 0 : 1;
}

sub store {
    my $self = shift;

    unless (exists $self->{errors}) {
        $self->validate;
    }

    die "Can't store with errors" if $self->{_errors};

    delete $self->{_errors};

    if ($self->{_id}) {
        die "_rev required" unless $self->{_rev};
        return $cdb->put($self->{_id}, { %$self })
    }
    else {
        delete $self->{_rev};
        return $cdb->post({ %$self });
    }
}

#    my ($interpreter, $interpreter_version, $interpreter_archname, $interpreter_config) 
#        = $self->_required_param(qw(interpreter interpreter_version interpreter_archname interpreter_config));

#    die "grade must be pass, fail, na or unknown\n" unless ($grade =~ m/^(pass|fail|na|unknown)$/);



1;
