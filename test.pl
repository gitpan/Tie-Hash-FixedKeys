# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..1\n"; }
END {print "not ok 1\n" unless $loaded;}
use Tie::Hash::FixedKeys;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

my %hash;

my @keys = qw(one two three);

tie %hash, 'Tie::Hash::FixedKeys', @keys;

$hash{one} = 1;
print $hash{one} == 1 ? '' : 'not ', "ok 2\n";
$hash{two} = 2;
print $hash{two} == 2 ? '' : 'not ', "ok 3\n";

eval { $hash{four} = 4 };
print $hash{four} == 4 ? 'not ' : '', "ok 4\n";
print defined $hash{four} ? 'not ' : '', "ok 5\n";
print exists $hash{four} ? 'not ' : '', "ok 6\n";

delete $hash{one};
print $hash{one} == 1 ? 'not ' : '', "ok 7\n";
print defined $hash{one} ? 'not ' : '', "ok 8\n";
print exists $hash{one} ? '' : 'not ', "ok 9\n";

delete $hash{four};
print $hash{four} == 4 ? 'not ' : '', "ok 10\n";
print defined $hash{four} ? 'not ' : '', "ok 11\n";
print exists $hash{four} ? 'not ' : '', "ok 12\n";
