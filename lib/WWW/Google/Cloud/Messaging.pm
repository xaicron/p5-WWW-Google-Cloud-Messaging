package WWW::Google::Cloud::Messaging;

use strict;
use warnings;
use 5.008_001;

use Carp qw(croak);
use LWP::UserAgent;
use HTTP::Request;
use JSON qw(encode_json);
use Class::Accessor::Lite (
    new => 0,
    rw  => [qw/ua api_url api_key/],
);

use WWW::Google::Cloud::Messaging::Response;

our $VERSION = '0.02';

our $API_URL = 'https://android.googleapis.com/gcm/send';

sub new {
    my ($class, %args) = @_;
    croak 'Usage: WWW::Google::Cloud::Messaging->new(api_key => $api_key)' unless defined $args{api_key};

    $args{ua}      ||= LWP::UserAgent->new(agent => __PACKAGE__.'/'.$VERSION);
    $args{api_url} ||= $API_URL;

    bless { %args }, $class;
}

sub send {
    my ($self, $payload) = @_;
    croak 'Usage: $gcm->send(\%payload)' unless ref $payload;

    if (exists $payload->{delay_while_idle}) {
        $payload->{delay_while_idle} = $payload->{delay_while_idle} ? JSON::true : JSON::false;
    }

    my $req = HTTP::Request->new(POST => $self->api_url);
    $req->header(Authorization  => 'key='.$self->api_key);
    $req->header('Content-Type' => 'application/json; charset=UTF-8');
    $req->content(encode_json $payload);

    my $res = $self->ua->request($req);
    return WWW::Google::Cloud::Messaging::Response->new($res);
}

1;
__END__

=encoding utf-8

=for stopwords

=head1 NAME

WWW::Google::Cloud::Messaging - Google Cloud Messaging (GCM) Client Library

=head1 SYNOPSIS

  use WWW::Google::Cloud::Messaging;

  my $api_key = 'Your API Key';
  my $gcm = WWW::Google::Cloud::Messaging->new(api_key => $api_key);

  my $res = $gcm->send({
      registration_ids => [ $reg_id, ... ],
      collapse_key     => $collapse_key,
      data             => {
        message => 'blah blah blah',
      },
  });

  die $res->error unless $res->is_success;

  my $results = $res->results;
  while (my $result = $results->next) {
      my $reg_id = $result->target_reg_id;
      if ($result->is_success) {
          say sprintf 'message_id: %s, reg_id: %s',
              $result->message_id, $reg_id;
      }
      else {
          warn sprintf 'error: %s, reg_id: %s',
              $result->error, $reg_id;
      }

      if ($result->has_canonical_id) {
          say sprintf 'reg_id %s is old! refreshed reg_id is %s',
              $reg_id, $result->registration_id;'
      }
  }

=head1 DESCRIPTION

WWW::Google::Cloud::Messaging is Google Cloud Messaging (GCM) Client Library.

Currently support JSON API only.

SEE ALSO L<< http://developer.android.com/guide/google/gcm/gcm.html#send-msg >>.

=head1 METHODS

=head2 new(%args)

Create a WWW::Google::Cloud::Messaging instance.

  my $gcm = WWW::Google::Cloud::Messaging->new(api_key => $api_key);

Supported options are:

=over

=item api_key : Str

Required. Sets your API key.

For information obtaining API key, please check L<< http://developer.android.com/guide/google/gcm/gs.html#access-key >>.

=item api_url : Str

Optional. Default values is C<< $WWW::Google::Cloud::Messaging::API_URL >>.

=item ua : LWP::UserAgent

Optional. Sets custom LWP::UserAgent instance.

=back

=head2 send(\%payload)

Send message to GCM. Returned C<< WWW::Google::Cloud::Messaging::Response >> instance.

  my $res = $gcm->send({
      registration_ids => [ $reg_id ], # must be arrayref
      collapse_key     => '...',
      data             => {
          message   => 'xxxx',
          score     => 12345,
          is_update => JSON::true,
      },
  });

For more information, SEE ALSO L<< http://developer.android.com/guide/google/gcm/gcm.html#send-msg >>.

=head1 AUTHOR

xaicron E<lt>xaicron@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2012 - xaicron

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<< WWW::Google::Cloud::Messaging::Response >>

=cut
