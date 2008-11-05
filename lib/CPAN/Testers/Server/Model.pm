package CPAN::Testers::Server::Model;
##
## This file is auto-generated *** DO NOT EDIT ***
##
use Combust::RoseDB;

our $SVN = q$Id$;
our @table_classes;

{
  package CPAN::Testers::Server::Model::_Meta;
  use base qw(Combust::RoseDB::Metadata);
  use PerlOrg::DB::ConventionManager;
  sub registry_key { __PACKAGE__ }
  sub init_convention_manager { PerlOrg::DB::ConventionManager->new }
}
{
  package CPAN::Testers::Server::Model::_Base;
  use base qw(Combust::RoseDB::Object::toJson);

  sub init_db    { shift; our $db ||= Combust::RoseDB->new(@_, type => 'cpantesters') }
  sub meta_class {'CPAN::Testers::Server::Model::_Meta'}
  sub model      { our $model ||= bless [], 'CPAN::Testers::Server::Model'}
}
{
  package CPAN::Testers::Server::Model::_Object;
  use base qw(CPAN::Testers::Server::Model::_Base Rose::DB::Object);
}
{
  package CPAN::Testers::Server::Model::_Object::Cached;
  use base qw(CPAN::Testers::Server::Model::_Base Rose::DB::Object::Cached);
}

# Allow user defined methods to be added
eval { require CPAN::Testers::Server::Model::User }
  or $@ !~ m:^Can't locate CPANTesters/Model/User.pm: and die $@;

{ package CPAN::Testers::Server::Model::User;

use strict;

use base qw(CPAN::Testers::Server::Model::_Object);

__PACKAGE__->meta->setup(
  table   => 'cpantesters_users',

  columns => [
    id         => { type => 'integer', not_null => 1 },
    username   => { type => 'varchar', default => '', length => 128, not_null => 1 },
    name       => { type => 'varchar', length => 128 },
    api_key    => { type => 'varchar', length => 32 },
    email      => { type => 'varchar', default => '', length => 128, not_null => 1 },
    bitcard_id => { type => 'varchar', default => '', length => 40, not_null => 1 },
  ],

  primary_key_columns => [ 'id' ],

  unique_keys => [
    [ 'api_key' ],
    [ 'bitcard_id' ],
    [ 'username' ],
  ],
);

push @table_classes, __PACKAGE__;
}

{ package CPAN::Testers::Server::Model::User::Manager;

use strict;

use Combust::RoseDB::Manager;
our @ISA = qw(Combust::RoseDB::Manager);

sub object_class { 'CPAN::Testers::Server::Model::User' }

__PACKAGE__->make_manager_methods('users');
}

{ package CPAN::Testers::Server::Model;

  sub db  { shift; CPAN::Testers::Server::Model::_Object->init_db(@_);      }
  sub dbh { shift->db->dbh; }

  sub flush_caches {
    $_->meta->clear_object_cache for @table_classes;
  }

  sub user { our $user ||= bless [], 'CPAN::Testers::Server::Model::User::Manager' }

}
1;
