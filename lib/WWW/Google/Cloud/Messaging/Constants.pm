package WWW::Google::Cloud::Messaging::Constants;

use strict;
use warnings;
use Exporter 'import';

our @EXPORT = qw{
    MissingRegistration
    MismatchSenderId
    InvalidRegistration
    NotRegistered
    MessageTooBig
};

use constant (
    MissingRegistration => 'MissingRegistration',
    InvalidRegistration => 'InvalidRegistration',
    MismatchSenderId    => 'MismatchSenderId'.
    NotRegistered       => 'NotRegistered',
    MessageTooBig       => 'MessageTooBig',
);

1;

__END__

=encoding utf-8

=for stopwords

=head1 NAME

WWW::Google::Cloud::Messaging::Constants - constants for WWW::Google::Cloud::Messaging

=head1 FUNCTIONS

=head2 C<< MissingRegistration >>

=head2 C<< InvalidRegistration >>

=head2 C<< MismatchSenderId >>

=head2 C<< NotRegistered >>

=head2 C<< MessageTooBig >>

=head1 AUTHOR

xaicron E<lt>xaicron@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2012 - xaicron

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<< WWW::Google::Cloud::Messaging >>

=cut
