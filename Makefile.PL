use inc::Module::Install;
use Module::Install::AuthorTests;

name 'WWW-Google-Cloud-Messaging';
all_from 'lib/WWW/Google/Cloud/Messaging.pm';

requires 'Class::Accessor::Lite';
requires 'JSON';
requires 'LWP::UserAgent';
requires 'HTTP::Request';

test_requires 'Test::More', 0.98;
test_requires 'Test::Flatten', 0.09;
test_requires 'Test::SharedFork', 0.20;
test_requires 'Test::Fake::HTTPD', 0.03;

tests join q{ }, map { sprintf 't%s.t', '/*' x $_ } 1..3;
author_tests 'xt';

repository 'http://github.com/xaicron/p5-WWW-Google-Cloud-Messaging/';
bugtracker 'http://github.com/xaicron/p5-WWW-Google-Cloud-Messaging/issues';

WriteAll;

package MY;

# do not install README.pod
sub init_dirscan {
    my $self = shift;
    $self->SUPER::init_dirscan();
    delete $self->{PM}{'README.pod'};
}
