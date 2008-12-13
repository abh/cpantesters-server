package CPAN::Testers::Server::Report::Upgrade;
use strict;

use base qw(Exporter);
our @EXPORT_OK = qw(upgrade_data);

use Email::Simple;
use Email::Date qw(find_date);
use Data::Dump qw(dump);
use MIME::Base64 qw(encode_base64);

sub upgrade_data {
    my ($self, $doc, $force) = @_;

    return if !$force and $doc->{report}->{version} and $doc->{report}->{version} >= 0.21;
    
    print $doc->id, " ", $doc->{distribution}->{name} && $doc->{distribution}->{name}, "\n";
    
    my $update = 0;
    
    if (my $version = delete $doc->{version}) {
        $doc->{report}->{version} = $version;
        $update = 1;
    }

    if (my $version = delete $doc->{report_version}) {
        $doc->{report}->{version} = $version;
        $update = 1;
    }

    if ($doc->{report}->{version} <= 0.13) {
        my $report_email = $doc->{nntp}->{report};
        #dump($report_email);
        unless ($report_email) {
            # ... look for attachment
            warn "NO EMAIL!!";
        }

        my $email = Email::Simple->new(\$report_email);
        
        unless ($doc->{report}->{created_ts}) {
            #warn $email->as_string;
            #warn "FOO: ", $email->header('Date');
            my $date = find_date($email);
            $doc->{report}->{created_ts} = $date->epoch;
        }

        if (!$doc->{nntp}{msg_id} or $doc->{nntp}{id}) {
            $doc->{nntp}{msg_id} = delete $doc->{nntp}{id} || $email->header('Message-Id');
            $update = 1;
        }
        
        if ($doc->{nntp_id} or !$doc->{nntp}{num}) {
            my $old_num       = delete $doc->{nntp_id};
            $doc->{nntp}{num} = $doc->{nntp}{num} || $old_num;
            
            unless ($doc->{nntp}{num}) {
                my $xref = $email->header('Xref');
                ($doc->{nntp}{num}) = ($xref && $xref =~ m/nntp.perl.org .*perl.cpan.testers:(\d+)/);
            }
            
            $update = 1;
        }
    }

    if (my $report = delete $doc->{nntp}{report}) {
        $doc->attach(name    => 'email_report',
                     content => $report,
                     content_type => 'text/plain',
                    );
        $update = 1;
    }

    return unless $update;
    
    $doc->{report}->{version} = 0.21;

    #print dump($doc);    
    return $doc;

}

1;
