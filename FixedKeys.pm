# $Id: FixedKeys.pm,v 1.8 2004/10/23 16:05:19 dave Exp $

=head1 NAME

Tie::Hash::FixedKeys - Perl extension for hashes with fixed keys

=head1 SYNOPSIS

  use Tie::Hash::FixedKeys;

  my @keys = qw(forename surname date_of_birth gender);
  my %person;
  tie %person, 'Tie;::Hash::FixedKeys', @keys;

  @person{@keys} = qw(Fred Bloggs 19700101 M);

  $person{height} = "6'"; # generates a warning

or (new! improved!)

  use Tie::Hash::FixedKeys;

  my %person : FixedKeys(qw(forename surname date_of_birth gender));

=head1 DESCRIPTION

Tie::Hash::FixedKeys is a class which changes the behaviour of Perl hashes.
Any hash which is tied to this class can only contain a fixed set of keys.
This set of keys is given when the hash is tied. For example, after running
the code:

  my @keys = qw(forename surename date_of_birth gender);
  my %person;
  tie %person, 'Tie;::Hash::FixedKeys', @keys;

the hash C<%person> can only contain the keys forename, surname, 
date_of_birth and gender. Any attempt to set a value for another key
will generate a run-time warning.

=head2 ATTRIBUTE INTERFACE

From version 1.5, you can use attributes to set the keys for your hash.
You will need Attribute::Handlers version 0.76 or greater.

=head2 CAVEAT

The tied hash will always contain exactly one value for each of the keys
in the list. These values are initialised to C<undef> when the hash is
tied. If you try to C<delete> one if the keys, the effect is that the
value is reset to C<undef>.

=cut

package Tie::Hash::FixedKeys; 

use strict;

use Tie::Hash;
use Carp;
use vars qw(@ISA $VERSION);

use Attribute::Handlers autotie => { "__CALLER__::FixedKeys" => __PACKAGE__ };

@ISA = qw(Tie::StdHash);

$VERSION = sprintf "%d.%02d", '$Revision: 1.8 $ ' =~ /(\d+)\.(\d+)/;

=head1 METHODS

=head2 TIEHASH

Creates a tied hash containing all the keys initialised to C<undef>.

=cut

sub TIEHASH {
  my $class = shift;

  my %hash;
  @hash{@_} = (undef) x @_;

  bless \%hash, $class;
}

=head2 STORE

Attempts to store a value in the hash. If the key isn't in the valid
list (i.e. it doesn't already exist) the program croaks.

=cut

sub STORE {
  my ($self, $key, $val) = @_;

  unless (exists $self->{$key}) {
    croak "invalid key [$key] in hash\n";
  }
  $self->{$key} = $val;
}

=head2 DELETE

Delete a value from the hash. Actually it just sets the value back to
C<undef>.

=cut

sub DELETE {
  my ($self, $key) = @_;

  return unless exists $self->{$key};

  my $ret = $self->{$key};

  $self->{$key} = undef;

  return $ret;
}

=head2 CLEAR

Clears all values but resetting them to C<undef>.

=cut

sub CLEAR {
  my $self = shift;

  $self->{$_} = undef foreach keys %$self;
}

1;
__END__

=head1 AUTHOR

Dave Cross <dave@dave.org.uk>

=head1 COPYRIGHT

Copyright (C) 2001, Magnum Solutions Ltd.  All Rights Reserved.

This script is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

perl(1), perltie(1).

=cut

#
# $Log: FixedKeys.pm,v $
# Revision 1.8  2004/10/23 16:05:19  dave
# Improved test coverage.
#
# Revision 1.7  2002/09/23 19:00:32  dave
# Fixed to work under 5.8.0.
#
# Revision 1.6  2002/07/12 18:34:28  dave
# Corrected Attirbute::Handlers dependency
#
# Revision 1.5  2001/12/09 18:54:42  dave
# Added Attribute::Handlers interface.
#
# Revision 1.4  2001/09/03 20:03:53  dave
# Minor fixes.
#
# Revision 1.3  2001/09/02 16:55:18  dave
# Added RCS headers
#

