BEGIN { $ENV{REFINE_PACKAGE_ANON} = 1 };
use strict;
use Test::More;
use Refine;

plan skip_all => 'Package::Anon is not available' unless eval 'require Package::Anon;1';

eval <<'TEST_CLASS' or die $@;
package Test::Class;
sub new { bless {}, shift }
sub dump { 42 }
$INC{'Test/Class.pm'} = 'generated';
TEST_CLASS

{
  my $t = Test::Class->new;
  $t->$_refine(dump => sub { $_[0] }, other_method => sub { 42 });

  is ref $t, 'Test::Class::WITH::dump::other_method::_0', 'Test::Class::WITH::dump::other_method::_0';
  isa_ok($t, 'Test::Class');
  is $t->other_method, 42, 'other_method() on t';
  is $t->dump, $t, 't->dump is redefined';
}

done_testing;
