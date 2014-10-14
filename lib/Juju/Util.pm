package Juju::Util;

# ABSTRACT: helper methods for Juju

=head1 SYNOPSIS

  use Juju::Util;
  my $util = Juju::Util->new;
  my $charm = $util->query_cs('wordpress', 'precise');

=cut

use strict;
use warnings;
use HTTP::Tiny;
use JSON::PP;
use Function::Parameters qw(:strict);
use Moo;
use namespace::clean;

has series => (is => 'ro', default => sub { qr/precise|trusty|utopic/ });

=method query_cs

helper for querying charm store for charm details

B<Params>

=for :list
* C<charm>
name of charm to query
* C<series>
(optional) series to limit to (defaults: trusty)

=cut

method query_cs($charm, $series = "trusty") {
    my $cs_url = 'https://manage.jujucharms.com/api/3/charm';

    my $composed_url = sprintf("%s/%s/%s", $cs_url, $series, $charm);
    my $res = HTTP::Tiny->new->get($composed_url);
    die "Unable to query charm store: ".$res->{reason} unless $res->{success};
    return decode_json($res->{content});
}

1;
