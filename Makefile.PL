use inc::Module::Install;
use Module::Install::AuthorTests;

name 'WWW-Google-Cloud-Messaging';
all_from 'lib/WWW/Google/Cloud/Messaging.pm';

#requires '';

test_requires 'Test::More', 0.98;

tests join q{ }, map { sprintf 't%s.t', '/*' x $_ } 1..3;
author_tests 'xt';

repository 'http://github.com/xaicron/p5-WWW-Google-Cloud-Messaging/';
bugtracker 'http://github.com/xaicron/p5-WWW-Google-Cloud-Messaging/issues';

WriteAll;
