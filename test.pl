# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

use Test::Simple tests => 12;

END {print "not ok 1\n" unless $loaded;}

use Tie::Hash::FixedKeys;
$loaded = 1;
ok($loaded);


######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

my %hash : FixedKeys(qw(one two three));

$hash{one} = 1;
ok($hash{one} == 1);
$hash{two} = 2;
ok($hash{two} == 2);

eval { $hash{four} = 4 };
ok(not $hash{four} == 4);
ok(not defined $hash{four});
ok(not exists $hash{four});

delete $hash{one};
ok(not $hash{one} == 1);
ok(not defined $hash{one});
ok(exists $hash{one});

delete $hash{four};
ok(not $hash{four} == 4);
ok(not defined $hash{four});
ok(not exists $hash{four});
