use strict;
use warnings;
use Test::More;
use WWW::Google::Cloud::Messaging::Constants;

is MissingRegistration, 'MissingRegistration';
is InvalidRegistration, 'InvalidRegistration';
is MismatchSenderId   , 'MismatchSenderId';
is NotRegistered      , 'NotRegistered';
is MessageTooBig      , 'MessageTooBig';

done_testing;
