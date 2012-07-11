use strict;
use warnings;
use utf8;
use Test::More;
use Test::Flatten;
use Test::SharedFork;
use Test::Fake::HTTPD;
use JSON;

use WWW::Google::Cloud::Messaging;
use WWW::Google::Cloud::Messaging::Constants;

plan skip_all => 'THIS TEST IS NOT SUPPORTED ON YOUR OS' if $^O eq 'MSWin32';

sub new_gcm {
    WWW::Google::Cloud::Messaging->new(api_key => 'api_key', @_);
}

sub get_request_data {
    my $req = shift;
    decode_json +$req->content;
}

sub create_response_content {
    my %args = @_;
    return {
        multicast_id  => 12345,
        success       => 1,
        failure       => 0,
        canonical_ids =>0,
        results       => [],
        %args,
    };
}

sub create_response {
    my ($code, $content) = @_;
    $content = encode_json $content;
    return [$code => [
        'Content-Length' => length($content),
        'Content-Type'   => 'application/json; charset=UTF-8',
    ], [$content]];
}

subtest 'required payload' => sub {
    eval { new_gcm->send };
    like $@, qr/Usage: \$gcm->send\(\\%payload\)/;
};

subtest 'payload must be hashref' => sub {
    for my $payload ('foo', [], undef) {
        eval { new_gcm->send('foo') };
        like $@, qr/Usage: \$gcm->send\(\\%payload\)/;
    }
};

subtest 'send a message' => sub {
    my $httpd = run_http_server {
        my $req = shift;

        my $params = get_request_data +$req;
        is_deeply $params, {
            registration_ids => ['foo'],
            collapse_key     => 'collapse_key',
            data             => {
                message => 'メッセージ',
            },
        };

        is $req->header('Content-Type'), 'application/json; charset=UTF-8';
        is $req->header('Authorization'), 'key=api_key';

        my $content = create_response_content(results => [
            { message_id => 123456789 },
        ]);
        return create_response(200 => $content);
    };
    
    my $res = new_gcm(api_url => $httpd->endpoint)->send({
        registration_ids => [qw/foo/],
        collapse_key     => 'collapse_key',
        data             => {
            message => 'メッセージ',
        },
    });

    ok $res->is_success;
    ok !$res->error;
    is $res->success, 1;
    is $res->failure, 0;
    is $res->canonical_ids, 0;
    is $res->multicast_id, 12345;
    isa_ok $res->http_response, 'HTTP::Response';
    is $res->status_line, $res->http_response->status_line;

    my $results = $res->results;
    isa_ok $results, 'WWW::Google::Cloud::Messaging::Response::ResultSet';
    while (my $result = $results->next) {
        isa_ok $result, 'WWW::Google::Cloud::Messaging::Response::Result';
        ok $result->is_success;
        ok !$result->error;
        ok !$result->has_canonical_id;
        ok !$result->registration_id;
        is $result->message_id, 123456789;
        is $result->target_reg_id, 'foo';
    }
};

done_testing;
