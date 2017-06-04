requires 'Class::Accessor::Lite';
requires 'HTTP::Request';
requires 'JSON';
requires 'LWP::ConnCache';
requires 'LWP::Protocol::https';
requires 'LWP::UserAgent';
requires 'perl', '5.008_001';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'Test::Fake::HTTPD';
    requires 'Test::More';
    requires 'Test::SharedFork';
};
