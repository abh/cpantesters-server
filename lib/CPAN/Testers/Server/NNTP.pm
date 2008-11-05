package CPAN::Testers::Server::NNTP;
use strict;
use IO::Compress::Gzip qw(gzip $GzipError);
use Net::NNTP;

my $nntp;

use DBI;
sub cache_dbh {
    return DBI->connect("dbi:SQLite:$ENV{CBROOTLOCAL}/db/nntp_mirror.db");
}


sub _check_connection {
    my($num, $first, $last) = $nntp && $nntp->group("perl.cpan.testers");
    return $num ? $nntp : undef;
}

sub nntp_connect {
  return $nntp if _check_connection;
 CONNECT:
  $nntp = Net::NNTP->new("nntp.perl.org")
     or die "Cannot connect to nntp.perl.org";
  unless (_check_connection) {
      warn "Could not connect; trying again in 3 seconds";
      sleep 3;
      goto CONNECT;
  }
  return $nntp;
}

sub get {
    my $msg_id = shift;

    my $retry = 0;
  RETRY:
    nntp_connect() unless $nntp;
    my $article = $nntp->article($msg_id);
    unless ($article or $retry) {
        $retry++;
        $nntp = undef;
        goto RETRY;
    }
    next unless $article;
    $article = join "", @{$article};
    my ($id) = ($article =~ m/Xref: nntp.perl.org .*?perl.cpan.testers:(\d+)/g);
    die "could not get id from article: [$article]" unless $id;
    printf "%7i %s\n", $id, $msg_id;
    return wantarray ? ($id, $article) : $article;
}

my $dbh = cache_dbh();

sub save {
    my ($id, $article) = @_;
    die "empty article for id $id?" unless $article and length($article) > 20;
    gzip \$article => \(my $gzip) or warn "Could not compress: $GzipError";
    #warn "gzip length: ", length($gzip);
    $dbh->do(q[replace into articles (id, article) values (?,?)], {}, $id, $gzip );
}

1;
